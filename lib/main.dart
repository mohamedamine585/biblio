import 'package:flutter/material.dart';
import 'package:flutter_application_1/Consts.dart';
import 'package:flutter_application_1/Views/AjouLecView.dart';
import 'package:flutter_application_1/Views/homepage.dart';
import 'Views/Lecteurspage.dart';
void main() {
  runApp( MaterialApp(
    routes: {
      LecteurPage :(context) => Lecteurpage(),
      AjouLecView:(context) => AjouterLecteur(),
    },
    debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    ));
}




