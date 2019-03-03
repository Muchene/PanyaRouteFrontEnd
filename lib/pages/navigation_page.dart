import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/map.dart';

//import 'package:latlong/latlong.dart';
import 'models.dart';


class NavigationPage extends StatefulWidget {
 
 final Location _start;
 final Location _finish;
 static const String route = "navigation";
 NavigationPage(this._start, this._finish);
 
  
  @override
  State<StatefulWidget> createState() => NavigationPageState();

}


class NavigationPageState extends State<NavigationPage>{

  bool _navigating = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController fromController = new TextEditingController();
  TextEditingController toController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    fromController.text = "Your location";
    toController.text = widget._finish.getName();
    _navigating = false;
  }


  Widget fromInput() {
    return  new Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width*.05,  
        top: MediaQuery.of(context).size.height*.05, 
        right:MediaQuery.of(context).size.width*.1),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.my_location),   
          new Flexible(
            child: new TextField(
              controller: fromController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: new EdgeInsets.symmetric(vertical:8, horizontal: 20),
                ),
              )
            ),
            new Icon(Icons.more_vert)
          ]
        )
      );
  }

  Widget toInput() {
    return  new Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width*.05,  
        top: 20,
        right:MediaQuery.of(context).size.width*.1),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.location_on),
           new Flexible(
             child: new TextField(
               controller: toController,
               decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 contentPadding: new EdgeInsets.symmetric(vertical:84, horizontal:20),
                ),
             )
            ),
            new Icon(Icons.swap_vert)
          ]
        )
      );
  }


  Widget navWidget() {
    return new Container(
      padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*.1, top: 10),
      child: new Row(
        children: <Widget>[
          new  RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            color:Colors.white,
            child: new Row(
              children: <Widget>[
                new Icon(Icons.directions,
                  color: Colors.black),
                new Container(
                  padding: EdgeInsets.only(left: 1),
                  child: new Text('Alternatives', style: new TextStyle( color: Colors.black)))
                ]),
            onPressed: startNavPressed,
          ),
          new Container(
            padding: EdgeInsets.only(left:5),
            child:  new  RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              color:Colors.blue,
              child: new Row(
                children: <Widget>[
                  new Icon(Icons.navigation,
                    color: Colors.white),
                  new Container(
                    padding: EdgeInsets.only(left: 5),
                    child: new Text('Start', style: new TextStyle( color: Colors.white)))
                  ]),
              onPressed: startNavPressed,
            )
          )
        ]
      )
    );
  }

  Widget estimateTime() {
    return new Container(
    );
  }

  Widget directionSearch(){
    return new Container(
      child: new Opacity(
        opacity: _navigating? 0.0: 1.0,
        child:new Container(
          height: MediaQuery.of(context).size.height*.30,
          child:new Card(
            color: Colors.white,
            elevation: 4.0,
            child: new Column(
              children: <Widget>[
                  fromInput(),
                  toInput(),
                  navWidget(),
                ],
              ),
            )
          )
        )
      );
  }

  Widget map() {
    return MapFactory().createMap();
  }

  void startNavPressed() {
    print("SETTING STATE:");
    setState(() {
       this._navigating = true;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      key:_scaffoldKey,
      drawer: buildDrawer(context, NavigationPage.route),
      body: new Stack(
        children: <Widget>[
          map(), 
          directionSearch(),
        ],
        )
    );
  }

}