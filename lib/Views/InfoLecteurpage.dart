
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:flutter_application_1/backend/Ouvrage.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';

class Infolecteurpage extends StatefulWidget {
  const Infolecteurpage({super.key});

  @override
  State<Infolecteurpage> createState() => _InfolecteurpageState();
}

class _InfolecteurpageState extends State<Infolecteurpage> {
  
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
    final  data = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final mysqlconnection = data[0] as MySqlConnection;
    final personnel = data[2] as Personnel;
    final lecteur = data[1] as Lecteur; 
     List<Ouvrage> ouvs = [];
     bool enunan = false;
   nom.text= lecteur.nom;
      prenom.text= lecteur.prenom;
   email.text= lecteur.email;
   cin.text= lecteur.Cin.toString();
   adresse.text = lecteur.addresse ?? "";
   
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: const Text("Ajouter un Lecteur")),
      ),
      body: Center(
        child: Column(
          children: [
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
                   
                 await personnel.update_lecteur(mySqlConnection: mysqlconnection,nomlecteur: nom.text,prenomlecteur: prenom.text,abonnement: abonnement,idlecteur: lecteur.idlecteur ?? -1,email: email.text);
            
               Navigator.pop(context,true);
              }, child: const Text("Mise à jour du lecteur")),
                 Container(
              height:120,
              child: Column(children: [
                const Text("L'Ouvrage Le plus demandé ",style: TextStyle(fontSize: 20),),
                FutureBuilder(
                  future: lecteur.get_Ouvrage_le_plus_demande(mySqlConnection: mysqlconnection),
                  builder: (context,snapshot){
                   if(snapshot.data?.isNotEmpty ?? false){
                     int count = snapshot.data?.keys.elementAt(0) ?? 0;
                    Ouvrage? ouvrage= snapshot.data?.values.first;
                   
                    return  Card(
                      elevation: 10,
                      child: 
                       
                          SingleChildScrollView(
                                child: Row(
                                  children: [
                                    SizedBox(width: 50,),
                                    SingleChildScrollView(
                                      child: Container(
                                        height: 70,
                                        width: 400,
                                        child: Row(
                                          children: [
                                            Text("${ouvrage?.nomOuvrage}",style: TextStyle(fontSize: 20),), 
                                            const   SizedBox(width: 50),
                                            Text(" ${ouvrage?.nomAuteur}"),
                                          ],
                                       )) ),

                                    Container(
                                      width: 700,
                                      child: Row(
                                        children: [
                                          Text("Nombre de livres : ${ouvrage?.nb}" ,softWrap: true,), 
                                      const SizedBox(width: 20,),
                                      Text("${lecteur.prenom} ${lecteur.nom} a preté ${count} livres ",softWrap: true,),
                                      const SizedBox(width: 30,),
                                       Text("${ouvrage?.categorie ??  ' ' }"),
                                       
                                        ],
                                      ),
                                    ) ,
                                    
                                    Text("Date d'entrée : ${ouvrage?.date_entree.day}-${ouvrage?.date_entree.month}-${ouvrage?.date_entree.year}    "),
                                  
                                    SizedBox(width: 50,),
                                   
                                  ],
                                ),
                              ),
                          ) ;}
                       return const SizedBox();
                  })
              ]),
            ),
           const SizedBox(height: 15,),
          
           Container(height: 200,
           child: FutureBuilder(
            future: lecteur.get_Ouvrages(mySqlConnection: mysqlconnection),
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
            },))
          ],
        ),
      ) ,
    );
  }
}