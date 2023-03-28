import 'dart:developer';

import 'package:mysql1/mysql1.dart';

class Lecteur{
 late String nom , prenom , email ;
 late String ? addresse ;
 late int? Cin ;
 late int nb_prets ,nb_prets_actuels , nb_alertes ,fidelite , nb_ouv_max , abonnement , nb_abonn ;
  
 late DateTime date_entree , date_abonnement ;





  Lecteur.define(this.nom,this.prenom,this.email,this.Cin,this.addresse,this.date_entree,this.date_abonnement,this.nb_prets,this.nb_prets_actuels,this.nb_alertes,this.fidelite,this.nb_ouv_max,this.abonnement,this.nb_abonn);
 
 
  
}