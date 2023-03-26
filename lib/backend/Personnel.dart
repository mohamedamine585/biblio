import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Personnel {
 late String nom , prenom , email,grade,mot_de_passe,addresse;
   late int cin ;
 late int ? age , minutes_en_service , prets_effectues;
  late DateTime date_entree ;
 late DateTime ?derniere_activite ;
  
  Personnel();
  Personnel.define( this.nom, this.prenom, this.email, this.grade, this.age, this.date_entree, this.prets_effectues, this.mot_de_passe, this.addresse,this.cin, this.minutes_en_service);
 
  Future<Personnel?> Authentifier({
    required MySqlConnection mySqlConnection,
    required String nom,required String prenom , required String mot_de_passe
  })async{
    try {
      Personnel? user  ;
      final Results results1 = await mySqlConnection.query("select * from personnel where nompersonnel = ? and prenompersonnel = ? and mot_de_passe = ?",
      [
          nom,prenom,sha1.convert(utf8.encode(mot_de_passe)).toString()
      ]);
      
      if(results1.isNotEmpty ){
         user =  Personnel.define(nom, prenom, results1.elementAt(0)["email"],
         results1.elementAt(0)["grade"],
          results1.elementAt(0)["age"], 
          
          
           results1.elementAt(0)["date_entree"], 
           results1.elementAt(0)["pret_effectues"],
            mot_de_passe, 
           results1.elementAt(0)["addresse"],
           results1.elementAt(0)["cin"],
           results1.elementAt(0)["minutes_en_service"],);
      }
      final Results results2 = await mySqlConnection.query("update personnel set derniere_activite = ? where cin = ?",[
        DateTime.now().toUtc(),user?.cin
      ]);
      return user;
    } catch (e) {
      return null;
    }
  }
  Future<void> logout(MySqlConnection mySqlConnection )async{
    try {
       DateTime derniere_activite ;
      Results results = await mySqlConnection.query("select derniere_activite from personnel where cin = ?",[cin]);
    if(results.isNotEmpty) 
    {  derniere_activite = results.elementAt(0)["derniere_activite"];
       results = await mySqlConnection.query("update personnel set minutes_en_service = minutes_en_service + ? where cin = ?",[
         DateTimeRange(start: derniere_activite, end: DateTime.now().toUtc()).duration.inMinutes ,cin
       ]);
      }
    } catch (e) {
      print(e);
    }
  }
  Future<bool> ajouter_personnel(
    
   {required MySqlConnection mySqlConnection ,
    }
    
  )async{
     try {
      Results results =await mySqlConnection.query("select idpersonnel from personnel where prenompersonnel = ? and nompersonnel = ?",[prenom,nom]);

      if(results.isEmpty)  {results = await mySqlConnection.query("insert into personnel(nompersonnel,prenompersonnel,email,cin,grade,date_entree,pret_effectues,heures_en_service,derniere_activite,mot_de_passe,addresse) values(?,?,?,?,?,?,?,?,?,?,?)",[
      nom,prenom,email,cin,grade,date_entree,0,0,null,sha1.convert(utf8.encode(mot_de_passe)).toString(),addresse
       ]);
       return true;
          }  else{
            print("User already exists !");
          }   } catch (e) {
      print(e);
       
     }
     return false;
  }
}