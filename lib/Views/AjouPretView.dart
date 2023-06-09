

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/showdialog.dart';

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
   bool _dayserror = false;
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
                    onChanged: (value){
                   setState(() {
                     if (value.contains(RegExp(r'[a-zA-Z !@#\$&*~]'))  ){
                       _dayserror = true;
                    }
                    else{
                      _dayserror = false;
                    }
                   }); 
                  },

                decoration: InputDecoration(
                errorText: _dayserror? "La durée en jours est invalide":null,
                  hintText:"Durée en jours",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
              ),
            ),
                            SizedBox(height: 15),

             
             
                SizedBox(height: 40),
              TextButton(onPressed: ()async{

               if(!_dayserror) {DateTime date_deb = DateTime.now().toUtc() , date_fin = DateTime.now().add(Duration(days: int.parse(days.text))).toUtc();
                Pret? pret = Pret.define(null,null,null,null, nomlecteur.text,  prenomlecteur.text, nomouvrage.text,  nomauteur.text,date_deb,date_fin,personnel.nom,personnel.prenom,0);
                bool added =   await personnel.ajouter_pret(mySqlConnection: mySqlConnection,pret: pret,context: context);     
                if(added) {
               await personnel.envoyer_evertissements(mySqlConnection: mySqlConnection);
                  Navigator.of(context).pop();
                }}
                else{
                  sd("Durée de pret invalide", context);
                }
              }, child: const Text("Ajouter Pret"))
      
          ],
        ),
      ) ,
    );
    
  }
  bool daystest(String s){
     return RegExp(r'^[0-9]+$').hasMatch(s);
  }
}