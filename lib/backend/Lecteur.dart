import 'dart:developer';

import 'package:mysql1/mysql1.dart';

class Lecteur{
 late String nom , prenom , email ;
 late String ? addresse ;
 late int? Cin ;
 late int nb_prets ,nb_prets_actuels , nb_alertes ,fidelite , nb_ouv_max , abonnement , nb_abonn ;
  
 late DateTime date_entree , date_abonnement ;
   Lecteur();
  Lecteur.define(this.nom,this.prenom,this.email,this.Cin,this.addresse,this.date_entree,this.date_abonnement,this.nb_prets,this.nb_prets_actuels,this.nb_alertes,this.fidelite,this.nb_ouv_max,this.abonnement,this.nb_abonn);
  Future<List<Lecteur>?> get_lecteurs ({required MySqlConnection mySqlConnection})async{
      try {
       
      Results results =  await  mySqlConnection.query("select * from lecteur");
      
    List<Lecteur> list = List<Lecteur>.generate(results.length, (index) {
        return Lecteur.define(results.elementAt(index)["nomlecteur"]
        , results.elementAt(index)["prenomlecteur"]
        , results.elementAt(index)["email"]
        , results.elementAt(index)["cin"]
        , results.elementAt(index)["addresse"]
        , results.elementAt(index)["date_entree"]
        , results.elementAt(index)["date_abb"]
        , results.elementAt(index)["nb_prets"]
        , results.elementAt(index)["nb_prets_actuels"]
        , results.elementAt(index)["nb_alertes"],
         results.elementAt(index)["fidelite"],
         results.elementAt(index)["nb_ouv_max"],
         results.elementAt(index)["abonnement"],
         results.elementAt(index)["nb_abonn"]
);
    
     });
     print(list);
     print("object");
     return list;
      } catch (e) {
        print(e);
         return null;
      }
  }
 Future<bool> add_lecteur(
  {required MySqlConnection mySqlConnection ,

  }
 )async{
    try {
      final results = mySqlConnection.query(
        "insert into lecteur(nomlecteur,prenomlecteur,email,addresse,cin,date_entree,date_abb,nb_prets,nb_prets_actuels,nb_alertes,fidelite,nb_ouv_max,abonnement,nb_abonn) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[
          nom,prenom,email,addresse,Cin,DateTime.now().toUtc(),DateTime.now().toUtc(),0,0,0,0,abonnement*3,abonnement,1
        ]);
      return true;
       
    } catch (e) {
      log(e.toString());
      return false;
    }

 }
}