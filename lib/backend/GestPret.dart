import 'package:flutter_application_1/backend/MysqlDBConnection.dart';
import 'package:flutter_application_1/backend/Pret.dart';
import 'package:mysql1/mysql1.dart';

class GestPret {
  Future<Pret?> ajouter_pret(
    {
      required MySqlConnection mySqlConnection ,
      required String nomlecteur , 
      required String prenomlecteur, 
      required String nomouvrage , 
      required String auteur ,
      required String nompersonnel ,
      required String prenompersonnel,
      required int days,
    }
  )async{
    try{  Results query_on_lecteur = await mySqlConnection.query("select abonnement from lecteur where nomlecteur = ? and prenomlecteur = ? and nb_ouv_max > nb_prets_actuels and nb_alertes < 3",[
      nomlecteur,prenomlecteur
    ]);
   if(query_on_lecteur.isNotEmpty){
     if( query_on_lecteur.elementAt(0)["abonnement"] < days / 30 ){
      print("Ce lecteur ne peut pas ....");
    }else{
      Results query_on_ouvrage = await mySqlConnection.query("select nb_dispo from ouvrage where nomouvrage= ? and nomauteur = ?",[
        nomouvrage,auteur
      ]);
      if(query_on_ouvrage.isNotEmpty ){
      if(query_on_ouvrage.elementAt(0)["nb_dispo"] > 0 ) { DateTime date_deb = DateTime.now().toUtc() , date_fin = DateTime.now().add(Duration(days: days)).toUtc();
         Results valider_pret = await mySqlConnection.query("insert into pret(nomlecteur,prenomlecteur,nomouvrage,auteur,nompersonnel,prenompersonnel,debut_pret,fin_pret,termine) values(?,?,?,?,?,?,?,?,?)",[
          nomlecteur,prenomlecteur,nomouvrage,auteur,nompersonnel,prenompersonnel,date_deb,date_fin,false
         ]);
         valider_pret = await mySqlConnection.query("update lecteur set nb_prets = nb_prets +1 and nb_prets_actuels = nb_prets_actuels +1  where nomlecteur = ? and prenomlecteur = ? ",[
          nomlecteur,prenomlecteur
         ]);
         valider_pret = await mySqlConnection.query("update ouvrage set nb_pretes = nb_pretes +1 and nb_dispo = nb_dispo - 1 where nomouvrage = ? and nomauteur = ?",[
          nomouvrage,auteur
         ]);
         valider_pret = await mySqlConnection.query("update personnel set pret_effectues = pret_effectues + 1 where nompersonnel = ? and prenompersonnel = ?",[
          nompersonnel,prenompersonnel
         ]);
         return Pret(null,nomlecteur, prenomlecteur, nomouvrage, auteur,date_deb, date_fin, nompersonnel, prenompersonnel,0);}
      }
      else {
        print("Ouvrage indisponible !");
      }
    }
    return null;
    }}
    catch(e){
      print(e);
      return null;
    }
  }
  Future<void> delete_prets({required MySqlConnection mySqlConnection , 
  required String nomouvrage ,
   required String nomauteur , 
   required String nomlecteur,
   required String prenomlecteur,
   required int idpret,
   })async{
    try {
     await mySqlConnection.query("update lecteur set nb_prets_actuels = nb_prets_actuels - 1 where nomlecteur = ? and prenomlecteur = ?",[
        nomlecteur,prenomlecteur
      ]);
       mySqlConnection.query("update ouvrage set nb_dispo = nb_dispo + 1 and  nb_pretes = nb_pretes - 1 where nomouvrage = ? and nomauteur = ?",[
        nomouvrage,nomauteur
      ]);
     mySqlConnection.query("update pret set termine = 1 where idpret = ?",[idpret]);
    } catch (e) {
      print(e);
    }
  }
  Future<List<Pret?>> get_prets({required MySqlConnection mySqlConnection})async{
     try {
       Results results =await mySqlConnection.query("select * from pret");
       if(results.isNotEmpty){
        return List.generate(results.length, (index){
          return Pret(
            results.elementAt(index)["idpret"],
            results.elementAt(index)["nomlecteur"],
            results.elementAt(index)["prenomlecteur"],
             results.elementAt(index)["nomouvrage"],
              results.elementAt(index)["auteur"], 
              results.elementAt(index)["debut_pret"],
               results.elementAt(index)["fin_pret"],
                results.elementAt(index)["nompersonnel"], 
                results.elementAt(index)["prenompersonnel"],
                results.elementAt(index)["termine"]
                );
        });
       }
     } catch (e) {
       print(e);
     }
     return [];
  }
}