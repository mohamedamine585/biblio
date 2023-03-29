import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Pret{
  late int ? idpersonnel , idlecteur , idouvrage ;
  String nomouvrage, nomlecteur , auteur , prenomlecteur,nompersonnel,prenompersonnel;
  int termine;
   int? idpret;
  DateTime debut_pret , fin_pret ;
  Pret.define(this.idpret , this.nomlecteur,this.prenomlecteur,this.nomouvrage,this.auteur,this.debut_pret,this.fin_pret,this.nompersonnel,this.prenompersonnel,this.termine);

}