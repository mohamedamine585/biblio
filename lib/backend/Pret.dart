import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Pret{
 late String nomouvrage, nomlecteur , auteur , prenomlecteur,nompersonnel,prenompersonnel;
 late int termine;
  late int? idpret;
 late DateTime debut_pret , fin_pret ;
  Pret.define(this.idpret , this.nomlecteur,this.prenomlecteur,this.nomouvrage,this.auteur,this.debut_pret,this.fin_pret,this.nompersonnel,this.prenompersonnel,this.termine);

}