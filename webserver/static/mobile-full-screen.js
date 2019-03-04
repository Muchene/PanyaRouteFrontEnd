import Geolocation from 'ol/Geolocation.js';
import Map from 'ol/Map.js';
import View from 'ol/View.js';
import TileLayer from 'ol/layer/Tile.js';
import BingMaps from 'ol/source/BingMaps.js';



var isFlutter = false;
if (typeof MapChannel != "undefined") {
    isFlutter = true;
    MapChannel.postMessage("TRYING TO PASS THIS MESSAGE");
}else {
    console.log("Viewing page from a non-flutter browser")
}


var utils = {
    getNearest: function(coord){
      var coord4326 = utils.to4326(coord);    
      return new Promise(function(resolve, reject) {
        //make sure the coord is on street
        fetch(url_osrm_nearest + coord4326.join()).then(function(response) { 
          // Convert to JSON
          return response.json();
        }).then(function(json) {
          if (json.code === 'Ok') resolve(json.waypoints[0].location);
          else reject();
        });
      });
    },
    createFeature: function(coord) {
      var feature = new ol.Feature({
        type: 'place',
        geometry: new ol.geom.Point(ol.proj.fromLonLat(coord))
      });
      feature.setStyle(styles.icon);
      vectorSource.addFeature(feature);
    },
    createRoute: function(polyline) {
      // route is ol.geom.LineString
      var route = new ol.format.Polyline({
        factor: 1e5
      }).readGeometry(polyline, {
        dataProjection: 'EPSG:4326',
        featureProjection: 'EPSG:3857'
      });
      var feature = new ol.Feature({
        type: 'route',
        geometry: route
      });
      feature.setStyle(styles.route);
      vectorSource.addFeature(feature);
    },
    to4326: function(coord) {
      return ol.proj.transform([
        parseFloat(coord[0]), parseFloat(coord[1])
      ], 'EPSG:3857', 'EPSG:4326');
    }
  };


const view = new View({
  center: [0, 0],
  zoom: 2
});

const map = new Map({
  layers: [
    new TileLayer({
      source: new BingMaps({
        key: 'As1HiMj1PvLPlqc_gtM7AqZfBL8ZL3VrjaS3zIb22Uvb9WKhuJObROC-qUpa81U5',
        imagerySet: 'RoadOnDemand'
      })
    })
  ],
  target: 'map',
  view: view
});

const geolocation = new Geolocation({
  projection: view.getProjection(),
  tracking: true
});

geolocation.once('change:position', function() {
  view.setCenter(geolocation.getPosition());
  view.setResolution(2.388657133911758);
});