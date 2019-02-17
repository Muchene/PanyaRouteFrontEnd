import 'package:flutter/material.dart';
import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/drawer.dart';
import 'package:latlong/latlong.dart';
import 'models.dart';
import 'navigation_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';



class PanyaRouteHome extends StatefulWidget {
  static const String route = "panya_home";

  @override
  PanyaRouteHomeState createState() => new PanyaRouteHomeState();
 
}

class PanyaRouteHomeState extends State<PanyaRouteHome> {

  bool _isSearching = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  List<Location> locations = [
    new Location("Nairobi", LatLng(-1.2921, 36.8219)),
    new Location("Kikuyu",  LatLng(-1.2472, 36.6791)),
    new Location("Limuru",  LatLng(-1.1069, 36.6431)),
    new Location("Kiambu",  LatLng(-1.1462, 36.9665)),
    new Location("Gitaru",  LatLng(-1.2335, 36.6715))];
  TextEditingController searchBarController = new TextEditingController();
  WebController webController;

  @override
  void initState(){
    super.initState();
    _isSearching = false;
    searchBarController.addListener(searchBarListener);
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  void searchBarListener() {
     setState(() {
      _isSearching = searchBarController.text.isNotEmpty;
     });
  }

  Location getCurrentLocation() {
    return  Location("Nairobi", LatLng(-1.28512, 36.829));
  }

  void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadUrl("http://45.79.185.231:4574/index.html");
    this.webController.onPageStarted.listen((url) =>
        print("Loading $url")
    );
    this.webController.onPageFinished.listen((url) =>
        print("Finished loading $url")
    );
  }
  Widget suggestionList() {
    //  Transform.rotate(
    //   angle: -pi / 12.0,
    //   child:
    //  new FlutterMap(
    //   options: new MapOptions(
    //   center:getCurrentLocation().getLatLng(),
    //   zoom: 6.0,
    //   ),
    //   layers: [
    //     new TileLayerOptions(
    //       urlTemplate:
    //           "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    //       subdomains: ['a', 'b', 'c'], 
    //     )
    //   ],
    // );
    FlutterNativeWeb flutterWebView = new FlutterNativeWeb(
      onWebCreated: onWebCreated,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
        () => TapGestureRecognizer(),
        ),
      ].toSet(),
    );
    Widget map = flutterWebView; 

    if(!_isSearching) { //return the map
      return  map;
    }
    List<Widget> suggestionItem = new List();
    for (var loc in locations) {
      suggestionItem.add(new ListTile(
        leading: Icon(Icons.location_on),
        title: new Text(loc.getName()),
        onTap: (){
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(getCurrentLocation(), loc),
          )
          );
        },
        ));
    }

    return new ListView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * .12 
      ),
      children: suggestionItem,
    );
  }
  void searchButtonPressed() {
    setState(() {
      if(!_isSearching) {
       _scaffoldKey.currentState.openDrawer();
      }else if (_isSearching){
        _isSearching = false;
        FocusScope.of(context).requestFocus(new FocusNode());
        searchBarController.clear();
      }
    });
  }

  Widget searchButtonIcon() {
    if(!_isSearching) {
      return new Icon(Icons.menu);
    }else {
      return new Icon(Icons.arrow_back);
    }
  }

  Widget build(BuildContext context) {
    Widget searchBar = new Container(
      alignment: Alignment.topCenter,
      padding: new EdgeInsets.only(
        top: MediaQuery.of(context).size.height * .05,
        right: 10.0,
        left: 10.0),
        child: new Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          child: new Card(
            color: Colors.white,
            elevation: 4.0,
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: searchButtonIcon(),
                  onPressed: searchButtonPressed
                ),
                new Flexible(
                  child: new TextField(
                    controller: searchBarController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Hepa!',
                      contentPadding: new EdgeInsets.only(left: 20),
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      );

    
    return new Scaffold(
      key: _scaffoldKey,
      drawer: buildDrawer(context, PanyaRouteHome.route),
      body: new Stack(
        children: [
          suggestionList(),
          searchBar, 
        ],
      ),
    );
  }
}
