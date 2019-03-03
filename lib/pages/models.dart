
import 'package:latlong/latlong.dart';


class Location {
  String _locationName;
  LatLng _latLng;
  Location(this._locationName, this._latLng);

  LatLng getLatLng() => this._latLng;
  String getName() =>this._locationName;
}