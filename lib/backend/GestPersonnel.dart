import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_application_1/backend/MysqlDBConnection.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:hash/hash.dart';
import 'package:mysql1/mysql1.dart';

class GestPersonnel {

  Future<Personnel?> Authentifier({
    required MySqlConnection mySqlConnection,
    required String nom , 
    required String prenom , 
    required mot_de_passe,
  })async{
    try {
      Personnel? user  ;
      final Results results1 = await mySqlConnection.query("select * from personnel where nompersonnel = ? and prenompersonnel = ? and mot_de_passe = ?",
      [
          nom,prenom,sha1.convert(utf8.encode(mot_de_passe)).toString()
      ]);
      
      if(results1.isNotEmpty ){
         user =  Personnel(nom, prenom, results1.elementAt(0)["email"],
         results1.elementAt(0)["grade"],
          results1.elementAt(0)["age"], 
          
          results1.elementAt(0)["heures_activite"],
           results1.elementAt(0)["date_entree"], 
           results1.elementAt(0)["pret_effectues"],
            mot_de_passe, 
           results1.elementAt(0)["addresse"],
           results1.elementAt(0)["cin"]);
      }
      final Results results2 = await mySqlConnection.query("update personnel set derniere_activite = ? where cin = ?",[
        DateTime.now().toUtc(),user?.cin
      ]);
      return user;
    } catch (e) {
      return null;
    }
  }
 
  Future<Personnel?> ajouter_personnel(
    
   {required MySqlConnection mySqlConnection ,required String nom , 
   required String prenom ,
   required int cin , 
   required String email  ,
   required String grade ,
   required int? age ,
   required String mot_de_passe,
   required String addresse,
    }
    
  )async{
     try {
       final Results results = await mySqlConnection.query("insert into personnel(nompersonnel,prenompersonnel,email,cin,grade,date_entree,pret_effectues,heures_en_service,derniere_activite,mot_de_passe,addresse) values(?,?,?,?,?,?,?,?,?,?,?)",[
      nom,prenom,email,cin,grade,DateTime.now().toUtc(),0,0,null,sha1.convert(utf8.encode(mot_de_passe)).toString(),addresse
       ]);
       return Personnel( nom, prenom, email, grade, age, 0,DateTime.now() , 0,Crypt.sha256(mot_de_passe).hash,addresse,cin);
     } catch (e) {
      print(e);
       return null; 
       
     }
  }
}