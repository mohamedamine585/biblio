


import 'package:flutter/material.dart';
import 'package:flutter_application_1/Consts.dart';
import 'package:flutter_application_1/Views/AjouLecView.dart';
import 'package:flutter_application_1/Views/AjouPretView.dart';
import 'package:flutter_application_1/Views/AjoutOuvrage.dart';
import 'package:flutter_application_1/Views/AjoutPersonnel.dart';
import 'package:flutter_application_1/Views/AuthentificationView.dart';
import 'package:flutter_application_1/Views/InfoLecteurpage.dart';
import 'package:flutter_application_1/Views/Infoouvrage.dart';
import 'package:flutter_application_1/Views/OuvragePage%20copy.dart';
import 'package:flutter_application_1/Views/OuvragePage.dart';
import 'package:flutter_application_1/Views/Ouvrages_en_un_an.dart';
import 'package:flutter_application_1/Views/PageLectAverti.dart';
import 'package:flutter_application_1/Views/PretsPage.dart';
import 'package:flutter_application_1/Views/Statsview.dart';
import 'package:flutter_application_1/Views/homepage.dart';
import 'Views/Lecteurspage.dart';

void main() {
  runApp( MaterialApp(
    routes: {

      Homepage :(context)=> MyHomePage(),
      LecteurPage :(context) =>const Lecteurpage(),
      AjouOuvView:(context) =>const AjouterOuvrage(),
      AjouLecView:(context) =>const AjouterLecteur(),
      OuvragePage:(context)=>const Ouvragepage(),
      AjouPersView:(context)=>const AjouterPersonnel(),
      AuthenView :(context)=>const AuthentificationView(),
      AjouPretView:(context)=>const AjouterPret(),
      PretPage :(context)=>const PretsPage(),
      Infopage :(context)=>const Infolecteurpage(),
      PageLectAvertis :(context)=>const LecteurAverti(),
      OuvrageMqperpage :(context)=>const OuvrageMqperdpage(),
      statsview : (context)=>const StatsView(),
      ouvrages_en_un_an : (context) => const Ouvrage_en_un_an(),
      modouvrage : (context) => const Infoouvrage(),
    },
    debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const  AuthentificationView(),
    ));
}




