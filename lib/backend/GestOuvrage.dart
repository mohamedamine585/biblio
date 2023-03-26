import 'dart:ffi';

import 'package:flutter_application_1/backend/Ouvrage.dart';
import 'package:mysql1/mysql1.dart';

class GestOuvrages {

  Future<List<Ouvrage>?> get_Ouvrages({required MySqlConnection mySqlConnection})async{
     try {
    
               final Results results = await mySqlConnection.query("select * from ouvrage order by date_entree desc");
          List<Ouvrage> list = List.generate(results.length, (index) {
             return Ouvrage(results.elementAt(index)["nomouvrage"]
             , results.elementAt(index)["nomauteur"]
             , results.elementAt(index)["categorie"]
             , results.elementAt(index)["nb"]
             , results.elementAt(index)["nb_dispo"]
             , results.elementAt(index)["nb_perdu"]
             , results.elementAt(index)["prix"]
                
             , results.elementAt(index)["date_entree"]);
          });

          return list; 
     } catch (e) {
      print(e);
       return null;
     }
  }

  Future<Ouvrage?>  add_Ouvrage({required MySqlConnection mySqlConnection ,
  required String nomOuv , required String nomauteur , required double prix , required int nb , String? categorie})async{
     try {
      Results results ;
          results = await mySqlConnection.query("select idouvrage from ouvrage where nomouvrage = ? and nomauteur = ?",[
            nomOuv,nomauteur
          ]);
          if(results.isEmpty){
          results = await mySqlConnection.query("insert into ouvrage(nomouvrage,nomauteur,nb,nb_dispo,nb_perdu,categorie,date_entree,prix) values(?,?,?,?,?,?,?,?,?)",[
          nomOuv,nomauteur,nb,nb,0,categorie,DateTime.now().toUtc(),prix
        ]);}
        else{
          print("Ouvrage deja existe");
        }

        
        return Ouvrage(nomOuv, nomauteur, categorie ?? "", nb, nb, 0, prix, DateTime.now());
     } catch (e) {
      print(e);
       return null;
     }
  }


  
}