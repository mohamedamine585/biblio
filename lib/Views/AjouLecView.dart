
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/showdialog.dart';
import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
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
    final data =  ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final Personnel personnel = data[0];
    final MySqlConnection mySqlConnection = data[1];
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: const Text("Ajouter un Lecteur")),
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
               SizedBox(height: 20,),
              Container(
                height: 20,
                width: 300,
                child: Row(
                  children: [
                    Text("Abonnement      : A1"),
                    Checkbox(value: ischecked1, onChanged:(isc1){
                      setState(() {
                        ischecked1 = isc1!;
                        if(ischecked2)
                          ischecked2 = !ischecked2 ;
                        if(ischecked3)
                          ischecked3 = !ischecked3;
                      });
                    }),
                     Text("A2"),
                    Checkbox(value: ischecked2, onChanged:(isc2){
                      setState(() {
                        ischecked2 = isc2!;
                        if(ischecked1)
                          ischecked1 = !ischecked1 ;
                        if(ischecked3)
                          ischecked3 = !ischecked3;
                      });
                    }),
                     Text("Premium"),
                    Checkbox(value: ischecked3, onChanged:(isc3){
                      setState(() {
                        ischecked3 = isc3!;
                        if(ischecked2)
                          ischecked2 = !ischecked2 ;
                        if(ischecked1)
                          ischecked1 = !ischecked1;
                      });
                    }),
            ]  ),
              ),
                SizedBox(height: 20),
              TextButton(onPressed: ()async{
                int abonnement = 1;
                  if(ischecked1)
                     abonnement = 1;
                  if(ischecked2)
                     abonnement = 2 ;
                  if(ischecked3)
                     abonnement = 3;
                   
               
               if(RegExp(r'^[0-9]+$').hasMatch(cin.text)){ final lecteur =Lecteur.define(null, nom.text, prenom.text, email.text,int.parse(cin.text), adresse.text, DateTime.now(),DateTime.now(), 0,0,0,1,abonnement*3,abonnement,1);
                bool added= await personnel.add_lecteur(mySqlConnection: mySqlConnection,lecteur: lecteur);
                if(added) {
                  Navigator.of(context).pop();
                }}else{
                  sd("Cin Format Not Accepted", context);
                }
              }, child: const Text("Ajouter lecteur"))
      
          ],
        ),
      ) ,
    );
  }
}