import 'dart:ffi';

import 'package:mysql1/mysql1.dart';

class Ouvrage {
 late String nomOuvrage , nomAuteur ; 
 late String ?categorie ;
 late int nb , nb_dispo , nb_perdu;
 late double prix  ;
 late DateTime date_entree ;
  Ouvrage.define(this.nomOuvrage,this.nomAuteur,this.categorie,this.nb,this.nb_dispo,this.nb_perdu,this.prix,this.date_entree);
  

}