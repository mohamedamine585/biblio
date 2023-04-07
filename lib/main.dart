








import 'package:flutter/material.dart';
import 'package:flutter_application_1/Consts.dart';
import 'package:flutter_application_1/Views/AjouLecView.dart';
import 'package:flutter_application_1/Views/AjouPretView.dart';
import 'package:flutter_application_1/Views/AjoutOuvrage.dart';
import 'package:flutter_application_1/Views/AjoutPersonnel.dart';
import 'package:flutter_application_1/Views/AuthentificationView.dart';
import 'package:flutter_application_1/Views/InfoLecteurpage.dart';
import 'package:flutter_application_1/Views/OuvragePage%20copy.dart';
import 'package:flutter_application_1/Views/OuvragePage.dart';
import 'package:flutter_application_1/Views/PageLectAverti.dart';
import 'package:flutter_application_1/Views/PretsPage.dart';
import 'package:flutter_application_1/Views/Statsview.dart';
import 'package:flutter_application_1/Views/homepage.dart';
import 'Views/Lecteurspage.dart';
void main() {
  runApp( MaterialApp(
    routes: {

      Homepage :(context)=> MyHomePage(),
      LecteurPage :(context) => Lecteurpage(),
      AjouOuvView:(context) => AjouterOuvrage(),
      AjouLecView:(context) => AjouterLecteur(),
      OuvragePage:(context)=> Ouvragepage(),
      AjouPersView:(context)=>AjouterPersonnel(),
      AuthenView :(context)=> AuthentificationView(),
      AjouPretView:(context)=>AjouterPret(),
      PretPage :(context)=> PretsPage(),
      Infopage :(context)=>Infolecteurpage(),
      PageLectAvertis :(context)=>LecteurAverti(),
      OuvrageMqperpage :(context)=>OuvrageMqperdpage(),
      statsview : (context)=>StatsView(),
    },
    debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthentificationView(),
    ));
}




