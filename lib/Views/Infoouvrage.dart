import 'package:flutter/material.dart';

import 'package:flutter_application_1/backend/Ouvrage.dart';
import 'package:mysql1/mysql1.dart';

class Infoouvrage extends StatefulWidget {
  const Infoouvrage({super.key});

  @override
  State<Infoouvrage> createState() => _InfoouvrageState();
}

class _InfoouvrageState extends State<Infoouvrage> {
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
  Widget build(BuildContext context) {
       final data = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final Ouvrage ouvrage = data[0]  ;
    final MySqlConnection mySqlConnection = data[1];
    nom.text = ouvrage.nomOuvrage ;
    auteur.text = ouvrage.nomAuteur ; 
    nb.text = ouvrage.nb.toString();
    prix.text = ouvrage.prix.toString(); 
    categorie.text= ouvrage.categorie ?? "";
    return Scaffold(
      appBar: AppBar(
        title:const Center(child: const Text("Modifier un Ouvrage")),
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
              final  ouv = Ouvrage.define(ouvrage.idouvrage, nom.text, auteur.text, categorie.text, int.parse(nb.text), ouvrage.nb_dispo, ouvrage.nb_perdu, double.parse(prix.text), ouvrage.date_entree);
               await ouvrage.Modifier_ouvrage(mySqlConnection: mySqlConnection, ouvrage: ouv);
              Navigator.of(context).pop();
              }, child: const Text("Modifier ouvrage"))
      
          ],
        ),
      ) ,
    );;
  }
}