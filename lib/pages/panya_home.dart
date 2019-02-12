import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/drawer.dart';
import 'package:latlong/latlong.dart';




class PanyaRouteHome extends StatefulWidget {
  static const String route = "panya_home";

  @override
  PanyaRouteHomeState createState() => new PanyaRouteHomeState();
 
}

class PanyaRouteHomeState extends State<PanyaRouteHome> {

  bool _isSearching = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  List<String> locations = ["Nairobi", "Naivasha", "Limuru", "Kiambu", "Gitrau"];
  TextEditingController searchBarController = new TextEditingController();

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
      _isSearching = !searchBarController.text.isEmpty;
     });
    // if(_isSearching){
    //   print("SEARCH: ${searchBarController.text}");
    // }else{
    //   print("Shouldn't be searching");
    // }
  }

  Widget suggestionList() {
    Widget map = new FlutterMap(
      options: new MapOptions(
      center: new LatLng(1.29, 36.829),
      zoom: 6.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate:
              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        )
      ],
    );
    if(!_isSearching) { //return the map
      return  map;
    }
    List<Widget> suggestionItem = new List();
    for (var loc in locations) {
      suggestionItem.add(new ListTile(
        leading: Icon(Icons.location_on),
        title: new Text(loc)));
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
