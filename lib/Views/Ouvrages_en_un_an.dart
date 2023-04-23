import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:mysql1/mysql1.dart';

import '../backend/Ouvrage.dart';

class Ouvrage_en_un_an extends StatefulWidget {
  const Ouvrage_en_un_an({super.key});

  @override
  State<Ouvrage_en_un_an> createState() => _Ouvrage_en_un_anState();
}

class _Ouvrage_en_un_anState extends State<Ouvrage_en_un_an> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final lecteur = data[0] as Lecteur;
    final conn = data[1] as MySqlConnection;
      List<Ouvrage> ouvs = [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Ouvrages en possesion en un an : ${lecteur.nom} ${lecteur.prenom}"),
      ),
      body: FutureBuilder(
            future: lecteur.get_Ouvrages(mySqlConnection: conn),
            builder: (context,snapshot){
            if(snapshot.data != null) { return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context,index){
                  ouvs = snapshot.data ?? [];
                   return ListTile(
                      
                        title:
                          Card(child: 
                          InkWell(
                            onTap: (){},
                            child: Container(
                              height: 50,
                              width: 100,
                              child: SingleChildScrollView(
                                child: Row(
                                  children: [
                                    SizedBox(width: 50,),
                                    SingleChildScrollView(
                                      child: Container(
                                        width: 400,
                                        child: Row(
                                          children: [
                                            Text("${ouvs.elementAt(index).nomOuvrage}",style: TextStyle(fontSize: 20),), 
                                            const   SizedBox(width: 50),
                                            Text(" ${ouvs.elementAt(index).nomAuteur}"),
                                          ],
                                       )) ),

                                    Container(
                                      width: 350,
                                      child: Row(
                                        children: [
                                          Text("Nombre de livres : ${ouvs.elementAt(index).nb}" ), 
                                      const SizedBox(width: 20,),
                                      Text("${(ouvs.elementAt(index).nb) - (ouvs.elementAt(index).nb_dispo ) } prets "),
                                      const SizedBox(width: 30,),
                                       Text("${ouvs.elementAt(index).categorie ??  ' ' }"),
                                       
                                        ],
                                      ),
                                    ) ,
                                    
                                    Text("Date d'entrée : ${ouvs.elementAt(index).date_entree.day}-${ouvs.elementAt(index).date_entree.month}-${ouvs.elementAt(index).date_entree.year}    "),
                                  
                                    SizedBox(width: 50,),
                                   
                                  ],
                                ),
                              ))),
                          ),
                        
                        
                      );
                });}
                return const SizedBox();
            },));
    
  }
}