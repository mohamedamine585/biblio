import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Pret{
 late String nomouvrage, nomlecteur , auteur , prenomlecteur,nompersonnel,prenompersonnel;
 late int termine;
  late int? idpret;
 late DateTime debut_pret , fin_pret ;
  Pret();
  Pret.define(this.idpret , this.nomlecteur,this.prenomlecteur,this.nomouvrage,this.auteur,this.debut_pret,this.fin_pret,this.nompersonnel,this.prenompersonnel,this.termine);
 Future<bool> ajouter_pret(
    {
      required MySqlConnection mySqlConnection ,
  
    }
  )async{
    try{  Results query_on_lecteur = await mySqlConnection.query("select abonnement from lecteur where nomlecteur = ? and prenomlecteur = ? and nb_ouv_max > nb_prets_actuels and nb_alertes < 3",[
      nomlecteur,prenomlecteur
    ]);
   if(query_on_lecteur.isNotEmpty){
     if( query_on_lecteur.elementAt(0)["abonnement"] < DateTimeRange(start:debut_pret, end: fin_pret).duration.inDays / 30 ){
      print("Ce lecteur ne peut pas ....");
    }else{
      Results query_on_ouvrage = await mySqlConnection.query("select nb_dispo from ouvrage where nomouvrage= ? and nomauteur = ?",[
        nomouvrage,auteur
      ]);
      if(query_on_ouvrage.isNotEmpty ){
      if(query_on_ouvrage.elementAt(0)["nb_dispo"] > 0 ) { 
         Results valider_pret = await mySqlConnection.query("insert into pret(nomlecteur,prenomlecteur,nomouvrage,auteur,nompersonnel,prenompersonnel,debut_pret,fin_pret,termine) values(?,?,?,?,?,?,?,?,?)",[
          nomlecteur,prenomlecteur,nomouvrage,auteur,nompersonnel,prenompersonnel,debut_pret,fin_pret,false
         ]);
         valider_pret = await mySqlConnection.query("update lecteur set nb_prets = nb_prets +1 , nb_prets_actuels = nb_prets_actuels +1  where nomlecteur = ? and prenomlecteur = ? ",[
          nomlecteur,prenomlecteur
         ]);
         valider_pret = await mySqlConnection.query("update ouvrage set  nb_dispo = nb_dispo - 1 where nomouvrage = ? and nomauteur = ?",[
          nomouvrage,auteur
         ]);
         valider_pret = await mySqlConnection.query("update personnel set pret_effectues = pret_effectues + 1 where nompersonnel = ? and prenompersonnel = ?",[
          nompersonnel,prenompersonnel
         ]);
         return true;}
      }
      else {
        print("Ouvrage indisponible !");
      }
    }
    }}
    catch(e){
      print(e);
    }
    return false;
  }
  Future<void> delete_prets({required MySqlConnection mySqlConnection , })async{
    try {

     await mySqlConnection.query("update lecteur set nb_prets_actuels = nb_prets_actuels - 1 where nomlecteur = ? and prenomlecteur = ?",[
        nomlecteur,prenomlecteur
      ]);
      await mySqlConnection.query("update lecteur set fidelite = fidelite + 1 where fidelite < 5 and nomlecteur = ? and prenomlecteur = ? ",[
        nomlecteur,prenomlecteur
      ]);
     await  mySqlConnection.query("update ouvrage set nb_dispo = nb_dispo + 1  where nomouvrage = ? and nomauteur = ?",[
        nomouvrage,auteur
      ]);
     await mySqlConnection.query("update pret set termine = 1 where idpret = ?",[idpret]);
    } catch (e) {
      print(e);
    }
  }
  Future<List<Pret?>> get_prets({required MySqlConnection mySqlConnection})async{
     try {
       Results results =await mySqlConnection.query("select * from pret order by debut_pret desc");
       if(results.isNotEmpty){
        return List.generate(results.length, (index){
          return Pret.define(
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