import 'package:flutter/material.dart';
import 'package:flutter_application_1/Consts.dart';

import 'package:flutter_application_1/backend/MysqlDBConnection.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';

class AuthentificationView extends StatefulWidget {
  const AuthentificationView({super.key});

  @override
  State<AuthentificationView> createState() => _AuthentificationViewState();
}

class _AuthentificationViewState extends State<AuthentificationView> {
  final Mysqlconn = MysqlConn();
  @override
  late final TextEditingController nom ; 
   late final TextEditingController prenom ;
    late final TextEditingController mot_de_passe ; 
     late final TextEditingController Cmotdepasse ; 
     @override 
     void initState() {
    nom = TextEditingController();
    prenom = TextEditingController();
    mot_de_passe = TextEditingController();
    Cmotdepasse = TextEditingController();

  }
  @override 
  void dispose() {
    nom.dispose();
    prenom.dispose();
   mot_de_passe.dispose();
   Cmotdepasse.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: Mysqlconn.get_connection(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title:const Center(child: const Text("Authentification")),
          ),
          body: Center(
            child: Column(
              children: [
                  SizedBox(height: 200),
                Container(
                  width: 400,
                  child: TextField(
                    controller: nom,
                    decoration: InputDecoration(
                      hintText:"Nom",
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
                      hintText:"Prenom",
                      hintStyle: TextStyle(fontStyle: FontStyle.italic)
                    ),
                            ),
                  ),
                    SizedBox(height: 15),
                 Container(
                   width: 400,
                   child: TextField(
                    obscureText: true,
                      controller: mot_de_passe,
                    decoration: InputDecoration(
                      hintText:"Mot de passe",
                      hintStyle: TextStyle(fontStyle: FontStyle.italic)
                    ),
                           ),
                 ),
              const  SizedBox(height: 30,),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 54, 119, 225),shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                onPressed: ()async{
                  
                  final user = await Personnel().Authentifier(mySqlConnection: snapshot.data!,nom: nom.text,prenom: prenom.text,mot_de_passe: mot_de_passe.text);
                  if(user != null){
                    Navigator.of(context).pushNamedAndRemoveUntil(Homepage, (route) => false,arguments: [user,snapshot.data]);
                  }
                  else{
                    print("User not found !");
                  }
              }, child: const Text("Authentifier",style: TextStyle(color: Colors.white),))
                 
          
              ],
            ),
          ) ,
        );
      }
    );
  }
}