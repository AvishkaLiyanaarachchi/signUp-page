//import 'dart:js';
//import 'dart:html';
//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:railwayflutterapp/login2.dart';
import 'dart:developer';

void main() {
  runApp(MyApp());//takes the given widget and make it the root of the widget tree
}
//StatelessWidget used to make the MyApp itself a widget
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder>{

    Login.tag:(context) => Login(),
  };
  //build method describe how to display widget in other widgets
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito',
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
      routes: routes,
    );
  }
}

