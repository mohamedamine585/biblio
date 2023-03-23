

import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/GestOuvrage.dart';
import 'package:mysql1/mysql1.dart';

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

     @override 
     void initState() {
     nomauteur = TextEditingController();
      nomlecteur = TextEditingController();
     nomouvrage = TextEditingController();
     prenomlecteur = TextEditingController();

  }
  @override 
  void dispose() {
     nomauteur.dispose();
     nomlecteur.dispose();
     nomouvrage.dispose();
     prenomlecteur.dispose();
        super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final MySqlConnection mySqlConnection = ModalRoute.of(context)?.settings.arguments as MySqlConnection;
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: const Text("Ajouter un Ouvrage")),
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
                            SizedBox(height: 15),

             
             
                SizedBox(height: 40),
              TextButton(onPressed: ()async{              
                Navigator.of(context).pop();
              }, child: const Text("Ajouter Pret"))
      
          ],
        ),
      ) ,
    );
  }
}