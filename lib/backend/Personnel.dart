import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/showdialog.dart';
import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:flutter_application_1/backend/Ouvrage.dart';
import 'package:mysql1/mysql1.dart';

import 'Pret.dart';

class Personnel {
 late String nom , prenom , email,grade,mot_de_passe,addresse;
   late int cin ;
 late int ? age , minutes_en_service , prets_effectues ,idpersonnel;
  late DateTime date_entree ;
 late DateTime ?derniere_activite ;
  
  Personnel();
  Personnel.define( this.nom, this.prenom, this.email, this.grade, this.age, this.date_entree, this.prets_effectues, this.mot_de_passe, this.addresse,this.cin, this.minutes_en_service,this.idpersonnel);
  Personnel.forstats(this.nom,this.prenom,this.minutes_en_service);
  
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
         user =  Personnel.define(
          
          nom, prenom, results1.elementAt(0)["email"],
         results1.elementAt(0)["grade"],
          results1.elementAt(0)["age"], 
           results1.elementAt(0)["date_entree"], 
           results1.elementAt(0)["pret_effectues"],
            mot_de_passe, 
           results1.elementAt(0)["addresse"],
           results1.elementAt(0)["cin"],
           results1.elementAt(0)["minutes_en_service"],
           results1.elementAt(0)["idpersonnel"]);
           
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
   required Personnel personnel
    }
    
  )async{
     try {
      Results results =await mySqlConnection.query("select idpersonnel from personnel where prenompersonnel = ? and nompersonnel = ?",[prenom,nom]);

      if(results.isEmpty)  {results = await mySqlConnection.query("insert into personnel(nompersonnel,prenompersonnel,email,cin,grade,date_entree,pret_effectues,minutes_en_service,derniere_activite,mot_de_passe,addresse) values(?,?,?,?,?,?,?,?,?,?,?)",[
     personnel. nom,personnel.prenom,personnel. email,personnel. cin,personnel. grade,personnel. date_entree,personnel.prets_effectues,personnel.minutes_en_service,personnel.derniere_activite,personnel.mot_de_passe,personnel.addresse
       ]);
       return true;
          }  else{
            print("User already exists !");
          }   } catch (e) {
      print(e);
       
     }
     return false;
  }
   
   
   Future<bool> add_lecteur(
  {required MySqlConnection mySqlConnection , required Lecteur lecteur

  }
 )async{
    try {
      final results = mySqlConnection.query(
        "insert into lecteur(nomlecteur,prenomlecteur,email,addresse,cin,date_entree,date_abb,nb_prets,nb_prets_actuels,nb_alertes,fidelite,nb_ouv_max,abonnement,nb_abonn) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[
         lecteur. nom,lecteur. prenom,lecteur. email,lecteur. addresse,lecteur.Cin,DateTime.now().toUtc(),DateTime.now().toUtc(),0,0,0,0,lecteur. abonnement*3,lecteur.abonnement,1
        ]);
      return true;
       
    } catch (e) {
      print(e.toString());
      return false;
    }

 }


 Future<bool> supprimer_ouvrage({required MySqlConnection mySqlConnection , required Ouvrage ouvrage})async {
    try {
      
     await mySqlConnection.query("delete from avertissement where idpret in (select idpret from pret where idouvrage = ?);",[ouvrage.idouvrage]);
      await mySqlConnection.query("delete from pret where idouvrage = ?",[ouvrage.idouvrage]);
      Results results = await mySqlConnection.query("delete from ouvrage where idouvrage = ? ",[
        ouvrage.idouvrage
      ]);
      
      if(results.affectedRows != 0) {
        
        return true;
      }
      
    } catch (e) {
      print(e);
    }
    return false;
   }

   Future<bool> supprimer_lecteur({required MySqlConnection mySqlConnection , required Lecteur lecteur})async {
    try {
      print(lecteur.idlecteur);
       await mySqlConnection.query("update ouvrage set nb = nb - 1  ,nb_perdu = nb_perdu + 1    where idouvrage  in (select idouvrage from pret where  idlecteur = ? and termine = 0);"
        ,[lecteur.idlecteur]);
              await mySqlConnection.query("delete from avertissement where idlecteur = ?",[lecteur.idlecteur]);

      await mySqlConnection.query("delete from pret where idlecteur = ?",[lecteur.idlecteur]);
      await mySqlConnection.query("delete from avertissement where idlecteur = ?",[lecteur.idlecteur]);
      Results results = await mySqlConnection.query("delete from lecteur where idlecteur  = ? ",[
                lecteur.idlecteur

      ]);

      if(results.affectedRows != 0) {
        return true;
      }
      
    } catch (e) {
      print(e);
    }
    return false;
   }
   

   Future<List<Lecteur>?> get_lecteurs ({required MySqlConnection mySqlConnection})async{
      try {
       
      Results results =  await  mySqlConnection.query("select * from lecteur");
      
    List<Lecteur> list = List<Lecteur>.generate(results.length, (index) {
        return Lecteur.define(
          results.elementAt(index)["idlecteur"],
          results.elementAt(index)["nomlecteur"]
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


  
    
    Future<void> envoyer_evertissements({required MySqlConnection mySqlConnection})async{
      try {
     Results results =    await mySqlConnection.query("select idlecteur,idpret from pret where (fin_pret   < ? ) and termine = 0 and  not exists ( select idlecteur,idpret from avertissement where pret.idlecteur = idlecteur and pret.idpret = idpret)",[
      DateTime.now().toUtc()
     ]);
     results.forEach((element) async{
            await mySqlConnection.query("insert into avertissement(idlecteur,idpret) values(?,?)",[
              element["idlecteur"],element["idpret"]
            ]);
            await mySqlConnection.query("update lecteur set nb_alertes = nb_alertes +1  where idlecteur = ?",[
              element["idlecteur"]
            ]);
            await mySqlConnection.query(" update lecteur set fidelite = fidelite - 1 where fidelite > 0 and idlecteur = ?",[
              element["idlecteur"]
            ]);
      });
      } catch (e) {
        print(e);
      }
    }


    Future<List<Pret>> get_prets({required MySqlConnection mySqlConnection})async{
     try {
       Results results =await mySqlConnection.query("select idpret,pret.idpersonnel,pret.idlecteur,pret.idouvrage,nomlecteur,prenomlecteur,nomouvrage,nomauteur,debut_pret,fin_pret,nompersonnel,prenompersonnel,termine from pret join ouvrage on ouvrage.idouvrage = pret.idouvrage  join lecteur on pret.idlecteur = lecteur.idlecteur join personnel on personnel.idpersonnel = pret.idpersonnel order by idpret desc;");
       if(results.isNotEmpty){
        return List.generate(results.length, (index){
         return  Pret.define(
            results.elementAt(index)["idpret"],
            results.elementAt(index)["idlecteur"],
            results.elementAt(index)["idouvrage"],
            results.elementAt(index)["idpersonnel"],

            results.elementAt(index)["nomlecteur"],
            results.elementAt(index)["prenomlecteur"],
             results.elementAt(index)["nomouvrage"],
              results.elementAt(index)["nomauteur"], 
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
    

    Future<void> update_lecteur({required MySqlConnection mySqlConnection , required int abonnement ,required String email,
     required String nomlecteur , required  String prenomlecteur  , required int idlecteur})async{
      try {
         
            Results results = await mySqlConnection.query("select idlecteur from lecteur where idlecteur = ?", [
             idlecteur
            ]);
            DateTime dateTime = DateTime.now().toUtc();
            results=  await mySqlConnection.query("call injapp.update_lect_info(?,?,?,?,?,?)",[
              abonnement,dateTime,idlecteur,nomlecteur,prenomlecteur,email
            ]);
        print(results.affectedRows);
      } catch (e) {
        print(e);
      }
    }

    Future<void> delete_prets({required MySqlConnection mySqlConnection , required Pret pret })async{
    try {
    Results results = await mySqlConnection.query("update pret set termine = 1 , fin_pret = ? where idpret = ? and termine = 0",[DateTime.now().toUtc(),pret. idpret]);
    if(results.affectedRows != 0){ await mySqlConnection.query("update lecteur set nb_prets_actuels = nb_prets_actuels - 1 where idlecteur = ?",[
       pret. idlecteur
      ]);
      await mySqlConnection.query("update lecteur set fidelite = fidelite + 1 where fidelite < 5 and nb_alertes < 3 and idlecteur = ? ",[
      pret.idlecteur
      ]);
     await  mySqlConnection.query("update ouvrage set nb_dispo = nb_dispo + 1  where idouvrage = ?",[
       pret. idouvrage
      ]);}
     
    } catch (e) {
      print(e);
    }}


    Future<List<Lecteur>?> get_lecteurs_avertis({required MySqlConnection mySqlConnection})async{
        try {
            await envoyer_evertissements(mySqlConnection: mySqlConnection);

      Results results =  await  mySqlConnection.query("select  fidelite,lecteur.idlecteur, nomlecteur,prenomlecteur,cin,nb_alertes,email,nb_prets,nb_prets_actuels,nb_ouv_max,abonnement,nb_abonn  from avertissement join lecteur on avertissement.idlecteur = lecteur.idlecteur join pret on avertissement.idpret = pret.idpret join ouvrage on pret.idouvrage = ouvrage.idouvrage where nb_alertes > 0 group by avertissement.idlecteur ");
      
    List<Lecteur> list = List<Lecteur>.generate(results.length, (index) {
        return Lecteur.define(
          results.elementAt(index)["idlecteur"],
          results.elementAt(index)["nomlecteur"]
        , results.elementAt(index)["prenomlecteur"]
        , results.elementAt(index)["email"]
        , results.elementAt(index)["cin"]
        ,null
        ,null
        , null
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
     
     Future<bool> ajouter_pret(
    {
      required MySqlConnection mySqlConnection ,
       required Pret pret , 
       required BuildContext context
    }
  )async{
    try{  Results query_on_lecteur = await mySqlConnection.query("select idlecteur,abonnement from lecteur where nomlecteur = ? and prenomlecteur = ? and nb_ouv_max > nb_prets_actuels and nb_alertes < 3 and date_abb > ?",[
     pret. nomlecteur ,pret. prenomlecteur,DateTime.now().toUtc().subtract(Duration(days: 90))
    ]);
   if(query_on_lecteur.isNotEmpty){
     if( query_on_lecteur.elementAt(0)["abonnement"] < DateTimeRange(start:pret. debut_pret, end:pret. fin_pret).duration.inDays / 30 ){
      sd("L'abonnement de ce lecteur ne lui permet pas de preter ce livre pour toute cette période", context);
    }else{
      Results query_on_ouvrage = await mySqlConnection.query("select idouvrage,nb_dispo from ouvrage where nomouvrage= ? and nomauteur = ?",[
       pret. nomouvrage,pret. auteur
      ]);
      if(query_on_ouvrage.isNotEmpty ){
      if(query_on_ouvrage.elementAt(0)["nb_dispo"] > 0 ) { 
         Results valider_pret = await mySqlConnection.query("insert into pret(idouvrage,idpersonnel,idlecteur,debut_pret,fin_pret,termine) values(?,?,?,?,?,?)",[
      query_on_ouvrage.elementAt(0)["idouvrage"],  idpersonnel,query_on_lecteur.elementAt(0)["idlecteur"], pret. debut_pret,pret.fin_pret,false
         ]);
         valider_pret = await mySqlConnection.query("update lecteur set nb_prets = nb_prets +1 , nb_prets_actuels = nb_prets_actuels +1  where nomlecteur = ? and prenomlecteur = ? ",[
         pret. nomlecteur,pret. prenomlecteur
         ]);
         valider_pret = await mySqlConnection.query("update ouvrage set  nb_dispo = nb_dispo - 1 where nomouvrage = ? and nomauteur = ?",[
         pret. nomouvrage,pret. auteur
         ]);
         valider_pret = await mySqlConnection.query("update personnel set pret_effectues = pret_effectues + 1 where nompersonnel = ? and prenompersonnel = ?",[
         pret. nompersonnel,pret. prenompersonnel
         ]);
         return true;}
      }
      else {
       sd("Ouvrage indisponible !", context);
      }
    }
    }
    else{
      sd("Lecteur inexistant ou exclu ou il a dépassé le nb max ou son abonnement expiré ....", context);
    }}
    catch(e){
      print(e);
    }
    return false;
  }
 

    Future<bool>  add_Ouvrage({required MySqlConnection mySqlConnection ,required Ouvrage ouvrage ,required BuildContext context
 })async{
     try {
      Results results ;
          results = await mySqlConnection.query("select idouvrage from ouvrage where nomouvrage = ? and nomauteur = ?",[
           ouvrage. nomOuvrage,ouvrage. nomAuteur
          ]);
          if(results.isEmpty){
          results = await mySqlConnection.query("insert into ouvrage(nomouvrage,nomauteur,nb,nb_dispo,nb_perdu,categorie,date_entree,prix) values(?,?,?,?,?,?,?,?)",[
         ouvrage. nomOuvrage,ouvrage. nomAuteur,ouvrage.nb,ouvrage. nb,0,ouvrage.categorie,ouvrage.date_entree,ouvrage.prix
        ]);}
        else{
         return false;
        }

        
        return true;
     } catch (e) {
      print(e);
       return false;
     }
  }

  
  
  Future<List<Ouvrage>?> get_Ouvrages({required MySqlConnection mySqlConnection})async{
     try {
    
               final Results results = await mySqlConnection.query("select * from ouvrage order by date_entree desc");
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

Future<Set<dynamic>> get_stats({required MySqlConnection mySqlConnection})async{
  return{await get_personnels(mySqlConnection: mySqlConnection) ,await get_10Ouvrages(mySqlConnection: mySqlConnection),await get_10lecteurs(mySqlConnection: mySqlConnection)};
}

Future<List<Lecteur>?> get_10lecteurs({required MySqlConnection mySqlConnection})async{
      try {
       
      Results results =  await  mySqlConnection.query("select nomlecteur,prenomlecteur,nb_prets from lecteur");
      
    List<Lecteur> list = List<Lecteur>.generate(results.length, (index) {
        return Lecteur.forstats(
          results.elementAt(index)["nomlecteur"]
        , results.elementAt(index)["prenomlecteur"],
                 results.elementAt(index)["nb_prets"]

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


  Future<List<Ouvrage>?> get_10Ouvrages({required MySqlConnection mySqlConnection})async{
     try {
    
               final Results results = await mySqlConnection.query("select nomouvrage,nomauteur,( select count(idouvrage)  from pret where pret.idouvrage =ouvrage.idouvrage ) as count  from ouvrage order by count desc limit 10");
          List<Ouvrage> list = List.generate(results.length, (index) {
             return Ouvrage.forstats(

              results.elementAt(index)["nomouvrage"]
             , results.elementAt(index)["nomauteur"]
                
             , results.elementAt(index)["count"],
              
                );
          });

          return list; 
     } catch (e) {
      print(e);
       return null;
     }
  }
  
  Future<List<Personnel>> get_personnels({required MySqlConnection mySqlConnection})async{
try {
  Results results = await mySqlConnection.query("select nompersonnel,prenompersonnel,minutes_en_service from personnel");
 List<Personnel> list =  List<Personnel>.generate(results.length, (index){
    return Personnel.forstats(
      results.elementAt(index)["nompersonnel"]
      ,  results.elementAt(index)["prenompersonnel"], 
       results.elementAt(index)["minutes_en_service"]);
  });

  return list ;
} catch (e) {
  
}
return [];
  }
  
  Future<List<Ouvrage>?> get_Ouvrages_Mq_perdus({required MySqlConnection mySqlConnection})async{
     try {
    
               final Results results = await mySqlConnection.query("select * from ouvrage where idouvrage in (select idouvrage from pret where fin_pret < ? and termine = 0) order by date_entree desc",[
                DateTime.now().toUtc()
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