

import 'package:flutter/material.dart';

import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';

import '../backend/Pret.dart';

class AjouterPret extends StatefulWidget {
  const AjouterPret({super.key});

  @override
  State<AjouterPret> createState() => _AjouterPretState();
}

class _AjouterPretState extends State<AjouterPret> {

  @override
  late final TextEditingController nomouvrage ; 
   late final TextEditingController nomauteur ;
     late final TextEditingController nomlecteur ; 
          late final TextEditingController prenomlecteur ; 
          late final TextEditingController days ; 

     @override 
     void initState() {
      days = TextEditingController();
     nomauteur = TextEditingController();
      nomlecteur = TextEditingController();
     nomouvrage = TextEditingController();
     prenomlecteur = TextEditingController();

  }
  @override 
  void dispose() {
    days.dispose();
     nomauteur.dispose();
     nomlecteur.dispose();
     nomouvrage.dispose();
     prenomlecteur.dispose();
        super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final list= ModalRoute.of(context)?.settings.arguments as List<dynamic> ;
     MySqlConnection mySqlConnection = list[0];
     Personnel personnel = list[1];
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: const Text("Ajouter un Pret")),
      ),
      body: Center(
        child: Column(
          children: [
              SizedBox(height: 150),
            Container(
              width: 400,
              child: TextField(
                controller: nomouvrage,
                decoration: InputDecoration(
                  hintText:"Nom de l'ouvrage",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
              ),
            ),
              SizedBox(height: 15),
              Container(
                 width: 400,
                child: TextField(
                  controller: nomauteur,
                decoration: InputDecoration(
                  hintText:"Nom de l'auteur",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                        ),
              ),
                SizedBox(height: 15),
             Container(
               width: 400,
               child: TextField(
                  controller: nomlecteur,
                decoration: InputDecoration(
                  hintText:"Nom lecteur",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                       ),
             ),
             SizedBox(height: 15),
            Container(
               width: 400,
              child: TextField(
                  controller: prenomlecteur,
                 
                decoration: InputDecoration(
                
                  hintText:"Prenom lecteur",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
              ),
            ),
             Container(
               width: 400,
              child: TextField(
                  controller: days,
                 
                decoration: InputDecoration(
                
                  hintText:"Duration in days",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
              ),
            ),
                            SizedBox(height: 15),

             
             
                SizedBox(height: 40),
              TextButton(onPressed: ()async{   
                DateTime date_deb = DateTime.now().toUtc() , date_fin = DateTime.now().add(Duration(days: int.parse(days.text))).toUtc();
                Pret? pret = Pret.define(null, nomlecteur.text,  prenomlecteur.text, nomouvrage.text,  nomauteur.text,date_deb,date_fin,personnel.nom,personnel.prenom,0);
                bool added =   await pret.ajouter_pret(mySqlConnection: mySqlConnection);     
                if(added) {
                  Navigator.of(context).pop();
                }
              }, child: const Text("Ajouter Pret"))
      
          ],
        ),
      ) ,
    );
  }
}