

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/showdialog.dart';
import 'package:flutter_application_1/backend/Ouvrage.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';

class AjouterOuvrage extends StatefulWidget {
  const AjouterOuvrage({super.key});

  @override
  State<AjouterOuvrage> createState() => _AjouterOuvrageState();
}

class _AjouterOuvrageState extends State<AjouterOuvrage> {
  @override
  late final TextEditingController nom ; 
   late final TextEditingController auteur ;
    late final TextEditingController nb ; 
     late final TextEditingController prix ; 
          late final TextEditingController categorie ; 

     @override 
     void initState() {
    nom = TextEditingController();
    auteur = TextEditingController();
    nb = TextEditingController();
    prix = TextEditingController();
  categorie = TextEditingController();
  }
  @override 
  void dispose() {
    nom.dispose();
    auteur.dispose();
    nb.dispose();
    prix.dispose();
        super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final Personnel personnel = data[0];
    final MySqlConnection mySqlConnection = data[1];
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
                controller: nom,
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
                  controller: auteur,
                decoration: InputDecoration(
                  hintText:"nom de l'auteur",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                        ),
              ),
                SizedBox(height: 15),
             Container(
               width: 400,
               child: TextField(
                  controller: nb,
                decoration: InputDecoration(
                  hintText:"nb",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                       ),
             ),
             SizedBox(height: 15),
            Container(
               width: 400,
              child: TextField(
                  controller: prix,
                 
                decoration: InputDecoration(
                
                  hintText:"prix d'ouvrage en DT",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
              ),
            ),
                            SizedBox(height: 15),

              Container(
                 width: 400,
                child: TextField(
                  controller: categorie,
                decoration: InputDecoration(
                  hintText:"catégorie de l'ouvrage ",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                        ),
              ),
             
               const SizedBox(height: 40),
              TextButton(onPressed: ()async{    
                Ouvrage ouvrage =Ouvrage.define(null,nom.text, auteur.text, categorie.text , int.parse(nb.text), int.parse(nb.text), 0,double.parse(prix.text), DateTime.now().toUtc())        ;
              final added = await  personnel.add_Ouvrage(mySqlConnection: mySqlConnection, ouvrage: ouvrage,context: context);
               if(added) {
                 Navigator.of(context).pop();
               }else{
                  sd("L'ouvrage déjà existe !",context);
                
               }
              }, child: const Text("Ajouter ouvrage"))
      
          ],
        ),
      ) ,
    );
  }
}