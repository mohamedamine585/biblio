import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/backend/GestLecteur.dart';
import 'package:flutter_application_1/backend/MysqlDBConnection.dart';
import 'package:mysql1/mysql1.dart';

class AjouterLecteur extends StatefulWidget {
  const AjouterLecteur({super.key});

  @override
  State<AjouterLecteur> createState() => _AjouterLecteurState();
}

class _AjouterLecteurState extends State<AjouterLecteur> {
  @override
  late final TextEditingController nom ; 
   late final TextEditingController prenom ;
    late final TextEditingController email ; 
     late final TextEditingController cin ; 
      late final TextEditingController adresse ; 
      bool ischecked1 = true, ischecked2 = false, ischecked3 = false;
     @override 
     void initState() {
    nom = TextEditingController();
    prenom = TextEditingController();
    email = TextEditingController();
    cin = TextEditingController();
    adresse = TextEditingController();

  }
  @override 
  void dispose() {
    nom.dispose();
    prenom.dispose();
    cin.dispose();
    adresse.dispose();
    email.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final MySqlConnection mySqlConnection = ModalRoute.of(context)?.settings.arguments as MySqlConnection;
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: const Text("Ajouter un Lecteur")),
      ),
      body: Center(
        child: Column(
          children: [
              SizedBox(height: 15),
            Container(
              width: 400,
              child: TextField(
                controller: nom,
                decoration: InputDecoration(
                  hintText:"Nom du lecteur",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
              ),
            ),
              SizedBox(height: 15),
              Container(
                 width: 400,
                child: TextField(
                  controller: prenom,
                decoration: InputDecoration(
                  hintText:"Prenom du lecteur",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                        ),
              ),
                SizedBox(height: 15),
             Container(
               width: 400,
               child: TextField(
                  controller: email,
                decoration: InputDecoration(
                  hintText:"email du lecteur : XXX@YYY.com",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                       ),
             ),
             SizedBox(height: 15),
            Container(
               width: 400,
              child: TextField(
                  controller: cin,
                 
                decoration: InputDecoration(
                
                  hintText:"CIN du lecteur",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
              ),
            ),
              SizedBox(height: 15),
              Container(
                 width: 400,
                child: TextField(
                  controller: adresse,
                decoration: InputDecoration(
                  hintText:"Adresse du lecteur",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                        ),
              ),
              Container(
                height: 20,
                width: 200,
                child: Row(
                  children: [
                    Text("A1"),
                    Checkbox(value: ischecked1, onChanged:(ischecked1){
                      setState(() {
                        ischecked1 = !ischecked1!;
                        if(ischecked2)
                          ischecked2 = !ischecked2 ;
                        if(ischecked3)
                          ischecked3 = !ischecked3;
                      });
                    }),
                     Text("A2"),
                    Checkbox(value: ischecked2, onChanged:(ischecked1){
                      setState(() {
                        ischecked2 = !ischecked2;
                        if(ischecked1!)
                          ischecked1 = !ischecked1! ;
                        if(ischecked3)
                          ischecked3 = !ischecked3;
                      });
                    }),
                     Text("Premium"),
                    Checkbox(value: ischecked3, onChanged:(ischecked1){
                      setState(() {
                        ischecked3 = !ischecked3;
                        if(ischecked2)
                          ischecked2 = !ischecked2 ;
                        if(ischecked1!)
                          ischecked1 = !ischecked1!;
                      });
                    }),
            ]  ),
              ),
                SizedBox(height: 15),
              TextButton(onPressed: ()async{
                int abonnement = 3;
                  if(ischecked1)
                     abonnement = 3;
                  if(ischecked2)
                     abonnement = 5 ;
                  if(ischecked3)
                     abonnement = 9;
                final lecteur = await GestionLecteurs().add_lecteur(mySqlConnection: mySqlConnection, nom: nom.text, prenom: prenom.text, email: email.text, cin:int.parse(cin.text), addresse: adresse.text,abonnement: abonnement );
                print(lecteur);
                Navigator.of(context).pop();
              }, child: const Text("Ajouter lecteur"))
      
          ],
        ),
      ) ,
    );
  }
}