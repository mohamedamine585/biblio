import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/showdialog.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';

class AjouterPersonnel extends StatefulWidget {
  const AjouterPersonnel({super.key});

  @override
  State<AjouterPersonnel> createState() => _AjouterPersonnelState();
}

class _AjouterPersonnelState extends State<AjouterPersonnel> {
  @override
  late final TextEditingController nom ; 
   late final TextEditingController prenom ;
    late final TextEditingController email ; 
     late final TextEditingController cin ; 
      late final TextEditingController adresse ; 
            late final TextEditingController mot_de_passe ; 
                  late final TextEditingController Cmotdepasse ; 
                  late final TextEditingController age ; 


      bool ischecked1 = true, ischecked2 = false, ischecked3 = false;
     @override 
     void initState() {
      age = TextEditingController();
    nom = TextEditingController();
    prenom = TextEditingController();
    email = TextEditingController();
    cin = TextEditingController();
    adresse = TextEditingController();
  mot_de_passe = TextEditingController();
  Cmotdepasse = TextEditingController();
  }
  @override 
  void dispose() {
    age.dispose();
    nom.dispose();
    prenom.dispose();
    cin.dispose();
    adresse.dispose();
    email.dispose();
    Cmotdepasse.dispose();
    mot_de_passe.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final personnel = data[0] as Personnel;
    final mysqlConn = data[1] as MySqlConnection;
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: const Text("Ajouter un Personnel")),
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
                  hintText:"Nom du Personnel",
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
                  hintText:"Prenom du Personnel",
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
                  hintText:"email du Personnel : XXX@YYY.com",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                       ),
             ),
              Container(
                 width: 400,
                child: TextField(
                  controller: age,
                decoration: InputDecoration(
                  hintText:"age",
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
                
                  hintText:"CIN du Personnel",
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
                  hintText:"Adresse du Personnel",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                        ),
              ),
               SizedBox(height: 15),
              Container(
                 width: 400,
                child: TextField(
                  controller: mot_de_passe,
                obscureText: true,
                decoration: InputDecoration(
                  
                  hintText:"Mot de passe du Personnel",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                        ),
              ),
               SizedBox(height: 15),
              Container(
                 width: 400,
                child: TextField(
                  obscureText: true,
                  controller: Cmotdepasse,
                decoration: InputDecoration(
                  hintText:"Confirmer le mot de passe ",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)
                ),
                        ),
              ),
               SizedBox(height: 20,),
              Container(
                height: 20,
                width: 350,
                child: Row(
                  children: [
                    Text("grade  : president"),
                    Checkbox(value: ischecked1, onChanged:(isc1){
                      setState(() {
                        ischecked1 = isc1!;
                        if(ischecked2)
                          ischecked2 = !ischecked2 ;
                        if(ischecked3)
                          ischecked3 = !ischecked3;
                      });
                    }),
                     Text("v-president"),
                    Checkbox(value: ischecked2, onChanged:(isc2){
                      setState(() {
                        ischecked2 = isc2!;
                        if(ischecked1)
                          ischecked1 = !ischecked1 ;
                        if(ischecked3)
                          ischecked3 = !ischecked3;
                      });
                    }),
                     Text("officier"),
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
                String grade = "precident";
                  if(ischecked1)
                     grade = "precident";
                  if(ischecked2)
                     grade = "vice president";
                  if(ischecked3)
                     grade = "officier";
                if(mot_de_passe.text == Cmotdepasse.text && mot_de_passe.text != "") {
                                    

                 if(RegExp(r'^[0-9]+$').hasMatch(cin.text)){
                  Personnel pers =  Personnel.define( nom.text, prenom.text, email.text, grade, int.parse(age.text),DateTime.now() , 0,Crypt.sha256(mot_de_passe.text).hash,adresse.text,int.parse(cin.text),0,null);
                  bool added =await personnel.ajouter_personnel(mySqlConnection: mysqlConn,personnel:pers);
                  if(added){
                    
                    Navigator.of(context).pop();
                  }else{
                 sd("Echec d'ajout", context);
                  }}else{
                  sd("Format de cin incompatible", context);

                  }
                }else{
                  sd("Confirm password please", context);
                }
              }, child: const Text("Ajouter Personnel"))
      
          ],
        ),
      ) ,
    );
  }
}