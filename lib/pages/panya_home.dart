import 'package:flutter/material.dart';
import '../widgets/map.dart';
import '../widgets/drawer.dart';
import 'package:latlong/latlong.dart';
import 'models.dart';
import 'navigation_page.dart';
import '../utils/permissions.dart';
import 'dart:async';



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
 

  @override
  void initState() {
    super.initState();
    requestPermission();
    _isSearching = false;
    searchBarController.addListener(searchBarListener);
  }

  void requestPermission() async {
    print("REQUESTING PERMISSION");
    PermissionRequest req = PermissionRequest();
    PermissionState permissionState = await req.getPermission(PermissionType.LOCATION);
    print("REQUESTED PERMISSION");
    switch (permissionState) {
      case PermissionState.GRANTED:
        print("GOT LOCATION PERMISSION");
        break;
      case PermissionState.DENIED:
        await new Future.delayed(new Duration(seconds : 1));
        print("DENIED PERMISSION");
        break;
      case PermissionState.SHOW_RATIONALE:
        //_view.showPermissionRationale();
        print("SHOW RATIONALE");
        break;
    }
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

  
  Widget suggestionList() {
    
    Widget map = MapFactory().createMap();

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
