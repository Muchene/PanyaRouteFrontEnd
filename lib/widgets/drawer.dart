import 'package:flutter/material.dart';
import '../pages/animated_map_controller.dart';
import '../pages/esri.dart';
import '../pages/home.dart';
import '../pages/map_controller.dart';
import '../pages/marker_anchor.dart';
import '../pages/offline_map.dart';
import '../pages/plugin_api.dart';
import '../pages/polyline.dart';
import '../pages/tap_to_add.dart';
import '../pages/on_tap.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  
  String currentProfilePic ="https://scontent.fbed1-1.fna.fbcdn.net/v/t1.0-9/38660601_10214261135535311_4878279813925699584_n.jpg?_nc_cat=108&_nc_ht=scontent.fbed1-1.fna&oh=61ac04dc21df085e1a31390f5e5852a1&oe=5CEA0460";
  Widget header = new UserAccountsDrawerHeader(
      accountEmail: new Text("ckigathi@gmail.com"),
      accountName: new Text("Carolyne"),
      currentAccountPicture: new GestureDetector(
        child: new CircleAvatar(
        backgroundImage: new NetworkImage(currentProfilePic),
        ),
        onTap: () => print("This is your current account."),
      ),
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new NetworkImage("https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
          fit: BoxFit.fill
        )
      )
    );
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        header,
        new ListTile(
          leading: new Icon(Icons.location_city),
          title: const Text('Work'),
          selected: currentRoute == HomePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, HomePage.route);
          },
        ),
        new ListTile(
          leading: new Icon(Icons.home),
          title: const Text('Home'),
          selected: currentRoute == HomePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, HomePage.route);
          },
        ),
      ],
    ),
  );
}
