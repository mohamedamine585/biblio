import 'dart:developer';

import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:flutter_application_1/backend/MysqlDBConnection.dart';
import 'package:mysql1/mysql1.dart';

class GestionLecteurs  {
  Future<List<Lecteur>?> get_lecteurs ({required MySqlConnection mySqlConnection})async{
      try {
        
      Results results =  await  mySqlConnection.query("select * from lecteur");
    return List<Lecteur>.generate(results.length, (index) {
        return Lecteur(results.elementAt(index)["nomlecteur"]
        , results.elementAt(index)["prenomlecteur"]
        , results.elementAt(index)["email"]
        , results.elementAt(index)["cin"]
        , results.elementAt(index)["addresse"]
        , results.elementAt(index)["date_entree"]
        , results.elementAt(index)["nb_prets"]
        , results.elementAt(index)["nb_prets_actuels"]
        , results.elementAt(index)["nb_alertes"],
         results.elementAt(index)["nb_prets"]
);
     });
      } catch (e) {
         return null;
      }
  }
 Future<Lecteur?> add_lecteur(
  {required MySqlConnection mySqlConnection ,
    required String nom , required String prenom ,required String email ,
    required int? cin , required String? addresse,
  }
 )async{
    try {
      final results = mySqlConnection.query(
        "insert into lecteur(nomlecteur,prenomlecteur,email,addresse,cin,date_entree,nb_prets,nb_prets_actuels,nb_alertes,fidelite) values (?,?,?,?,?,?,?,?,?,?)",[
          nom,prenom,email,addresse,cin,DateTime.now().toUtc(),0,0,0,0
        ]);
      print(results);
      return Lecteur(nom, prenom, email, cin ?? -1, addresse, DateTime.now(), 0,0,0,0);
       
    } catch (e) {
      log(e.toString());
      return null;
    }

 }
}