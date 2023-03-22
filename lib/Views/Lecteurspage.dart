import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/GestLecteur.dart';
import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mysql1/mysql1.dart';


class Lecteurpage extends StatefulWidget {
  const Lecteurpage({super.key});

  @override
  State<Lecteurpage> createState() => _LecteurpageState();
}

class _LecteurpageState extends State<Lecteurpage> {
  List<Lecteur>? Lecteurs = [];
  List<Lecteur> lecs = [];
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
    final mysqlconn = ModalRoute.of(context)?.settings.arguments as MySqlConnection ;
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
                  lecs.clear();
                  Lecteurs?.forEach((element) { 
                    if(element.prenom.toLowerCase().contains(value)  || (element.nom.toLowerCase().contains(value)) 
                  || element.prenom.toUpperCase().contains(value)  || (element.nom.toUpperCase().contains(value) ))
                   lecs.add(element);
                  
                  }); 
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
                future: GestionLecteurs().get_lecteurs(mySqlConnection: mysqlconn),
                builder: (context, snapshot) {
                   Lecteurs = snapshot.data  ;

                  return ListView.builder(
                      itemCount: lecs.length,
                      itemBuilder: (context,index){
                      final temps_abonn_restant =30- DateTimeRange(start: lecs.elementAt(index).date_abonnement, end: DateTime.now()).duration.inDays;
                      
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
                                        child: Text("${lecs.elementAt(index).nom} ${lecs.elementAt(index).prenom}")),
                                    ),
                                    Text("Date d'entrée : ${lecs.elementAt(index).date_entree.day}-${lecs.elementAt(index).date_entree.month}-${lecs.elementAt(index).date_entree.year}    ${lecs.elementAt(index).nb_prets } prets "),
                                    Text("    Abonnement : A${lecs.elementAt(index).abonnement}  ${lecs.elementAt(index).date_abonnement.day}-${lecs.elementAt(index).date_abonnement.month}-${lecs.elementAt(index).date_abonnement.year} : ${lecs.elementAt(index).date_abonnement.hour}:${lecs.elementAt(index).date_abonnement.minute}",style: TextStyle(color: Colors.blue),),
                                  
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
                                 },)
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
