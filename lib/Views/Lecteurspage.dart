import 'package:flutter/material.dart';
import 'package:flutter_application_1/Consts.dart';
import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mysql1/mysql1.dart';

import '../backend/Personnel.dart';


class Lecteurpage extends StatefulWidget {
  const Lecteurpage({super.key});

  @override
  State<Lecteurpage> createState() => _LecteurpageState();
}

class _LecteurpageState extends State<Lecteurpage> {
  List<Lecteur>? Lecteurs = [];
  String ?s;
  @override
  late final TextEditingController query ;
  @override
  void initState() {
    query = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  final data =  ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final personnel = data[0] as Personnel ;
    final mysqlconn = data[1]as MySqlConnection ;    
      List<Lecteur> lecs = [];

    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: Text("Lecteurs")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: 500,
            child: TextField(
              
              onChanged: (value) {
                setState(() {
                 s  = value;
                  
                });
              },
              controller: query,
               cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                          ),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18
                          ),),
            ),),
          
            Container(
              height: 630,
              child: FutureBuilder(
                future: personnel.get_lecteurs(mySqlConnection: mysqlconn),
                builder: (context, snapshot) {
                   Lecteurs = snapshot.data  ;
lecs = Lecteurs?.where((element) => element.prenom.toLowerCase().contains(s ?? "")  || (element.nom.toLowerCase().contains(s ?? "")) 
                  || element.prenom.toUpperCase().contains(s ?? "")  || (element.nom.toUpperCase().contains(s ?? "") )).toList() ?? [];
                  return ListView.builder(
                      itemCount: lecs.length,
                      itemBuilder: (context,index){
                      int temps_abonn_restant = 0;
                      try {
                       temps_abonn_restant = 30- DateTimeRange(start: lecs.elementAt(index).date_abonnement ?? DateTime.now(), end: DateTime.now()).duration.inDays;
                      } catch (e) {
                        temps_abonn_restant =  30- DateTimeRange(start: lecs.elementAt(index).date_abonnement ?? DateTime.now(), end: DateTime.now().add(Duration(days: 1))).duration.inDays;
                      }
                      return ListTile(
                      
                        title:
                          Card(child: 
                          InkWell(
                            onTap: ()async{
                        await  Navigator.of(context).pushNamed( Infopage,arguments: [mysqlconn,lecs.elementAt(index),personnel]);

                            },
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
                                        child: Text("${lecs.elementAt(index).nom} ${lecs.elementAt(index).prenom}")),
                                    ),
                                    Text("CIN : ${lecs.elementAt(index).Cin}    "),
                                    
                                    Text("Date d'entrée : ${lecs.elementAt(index).date_entree?.day}-${lecs.elementAt(index).date_entree?.month}-${lecs.elementAt(index).date_entree?.year}    ${lecs.elementAt(index).nb_prets_actuels } prets "),
                                    Text("    Abonnement : A${lecs.elementAt(index).abonnement}  ${lecs.elementAt(index).date_abonnement?.day}-${lecs.elementAt(index).date_abonnement?.month}-${lecs.elementAt(index).date_abonnement?.year} : ${lecs.elementAt(index).date_abonnement?.hour}:${lecs.elementAt(index).date_abonnement?.minute}",style: TextStyle(color: Colors.blue),),
                                  
                                    Text("  Reste : ${temps_abonn_restant}" ,style: TextStyle(color: temps_abonn_restant > 0 ? Colors.black : Colors.red),),
                                    SizedBox(width: 50,),
                                    RatingBar.builder(
                                      itemSize: 20,
                                 initialRating: (lecs.elementAt(index).fidelite).toDouble(),
                                 direction: Axis.horizontal,
                                 allowHalfRating: true,
                                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                 itemBuilder: (context, _) =>const Icon(
                                   Icons.star,
                                   color: Colors.amber,
                                 ),
                                 onRatingUpdate: (rating) {
                                   return;
                                 },),
                                const SizedBox(width: 15,),
                                TextButton(onPressed: ()async{
                                  final deleted = await personnel.supprimer_lecteur(mySqlConnection: mysqlconn, lecteur: lecs.elementAt(index));
                                  if(deleted){
                                   setState(() {
                                     lecs.remove(lecs.elementAt(index));
                                   });
                                  }
                                }, child: const Text("Supprimer le lecteur"))
                                  ],
                                ),
                              ))),
                          ),
                        
                        
                      );
                    });
                }
              )),]),
      ),);
            }
          
        
      
      
    
  }
