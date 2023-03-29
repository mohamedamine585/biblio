import 'dart:developer';

import 'package:mysql1/mysql1.dart';

import 'Ouvrage.dart';

class Lecteur{
  String nom , prenom , email ;
  String ? addresse ;
  int? Cin,idlecteur; 
  int nb_prets ,nb_prets_actuels , nb_alertes ,fidelite , nb_ouv_max , abonnement , nb_abonn ;
   
  DateTime date_entree , date_abonnement ;





  Lecteur.define( this.idlecteur,this.nom,this.prenom,this.email,this.Cin,this.addresse,this.date_entree,this.date_abonnement,this.nb_prets,this.nb_prets_actuels,this.nb_alertes,this.fidelite,this.nb_ouv_max,this.abonnement,this.nb_abonn);
 
 

 
 Future<Map<int,Ouvrage>?> get_Ouvrage_le_plus_demande({required MySqlConnection mySqlConnection})async{

  try {
    Results results = await mySqlConnection.query("select idouvrage , count(idouvrage) as count from pret where idlecteur = ? group by idouvrage order by count desc limit 1;",[
      idlecteur 
    ]);
     int count = results.elementAt(0)["count"];
    if(results.isNotEmpty){
      results = await mySqlConnection.query("select * from ouvrage where idouvrage = ?",[results.elementAt(0)["idouvrage"]]);
     final ouvrage =   Ouvrage.define(
        results.elementAt(0)["idouvrage"],
        results.elementAt(0)["nomouvrage"],
        results.elementAt(0)["nomauteur"],
        results.elementAt(0)["categorie"],
        results.elementAt(0)["nb"],
        results.elementAt(0)["nb_dispo"],
        results.elementAt(0)["nb_perdu"],
        results.elementAt(0)["prix"],
        results.elementAt(0)["date_entree"],
        
      );

      return {count:ouvrage};
    }
      } catch (e) {
    print(e);
  }
  return null;
 }

  Future<List<Ouvrage>?> get_Ouvrages({required MySqlConnection mySqlConnection })async{
     try {
       

    
               final Results results = await mySqlConnection.query("select * from ouvrage where exists(select 1 from pret where ouvrage.nomouvrage = pret.nomouvrage and ouvrage.nomauteur = pret.nomauteur and nomlecteur = ? and prenomlecteur = ? and termine = 0)  order by date_entree desc;",[
                nom,prenom
               ]);
          List<Ouvrage> list = List.generate(results.length, (index) {
             return Ouvrage.define(
                            results.elementAt(index)["idouvrage"],

              results.elementAt(index)["nomouvrage"]
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
 Future<List<Ouvrage>?> get_Ouvrages_en_un_an({required MySqlConnection mySqlConnection })async{
     try {
    
               final Results results = await mySqlConnection.query("call livres_en_un_an(?,?);",[
                DateTime.now().toUtc(),idlecteur
               ]);
          List<Ouvrage> list = List.generate(results.length, (index) {
             return Ouvrage.define(
                            results.elementAt(index)["idouvrage"],

              results.elementAt(index)["nomouvrage"]
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
 
  
}