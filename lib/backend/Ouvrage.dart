import 'dart:ffi';

import 'package:mysql1/mysql1.dart';

class Ouvrage {
 late String nomOuvrage , nomAuteur ; 
 late String ?categorie ;
 late int nb , nb_dispo , nb_perdu;
 late double prix  ;
 late DateTime date_entree ;
 Ouvrage();
  Ouvrage.define(this.nomOuvrage,this.nomAuteur,this.categorie,this.nb,this.nb_dispo,this.nb_perdu,this.prix,this.date_entree);
  
  Future<List<Ouvrage>?> get_Ouvrages({required MySqlConnection mySqlConnection})async{
     try {
    
               final Results results = await mySqlConnection.query("select * from ouvrage order by date_entree desc");
          List<Ouvrage> list = List.generate(results.length, (index) {
             return Ouvrage.define(results.elementAt(index)["nomouvrage"]
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

  Future<bool>  add_Ouvrage({required MySqlConnection mySqlConnection ,
 })async{
     try {
      Results results ;
          results = await mySqlConnection.query("select idouvrage from ouvrage where nomouvrage = ? and nomauteur = ?",[
            nomOuvrage,nomAuteur
          ]);
          if(results.isEmpty){
          results = await mySqlConnection.query("insert into ouvrage(nomouvrage,nomauteur,nb,nb_dispo,nb_perdu,categorie,date_entree,prix) values(?,?,?,?,?,?,?,?)",[
          nomOuvrage,nomAuteur,nb,nb,0,categorie,date_entree,prix
        ]);}
        else{
          print("Ouvrage deja existe");
        }

        
        return true;
     } catch (e) {
      print(e);
       return false;
     }
  }


}