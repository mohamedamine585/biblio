import 'dart:ffi';

import 'package:mysql1/mysql1.dart';

class Ouvrage {
  String nomOuvrage , nomAuteur ; 
  String ?categorie ;
  int? idouvrage;
  int nb , nb_dispo , nb_perdu;
  double prix  ;
  DateTime date_entree ;
  Ouvrage.define( this.idouvrage, this.nomOuvrage,this.nomAuteur,this.categorie,this.nb,this.nb_dispo,this.nb_perdu,this.prix,this.date_entree);
  

}