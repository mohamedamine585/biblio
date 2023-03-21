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
                  
                  });  print(lecs);
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
                  
                   print(Lecteurs);
                  return ListView.builder(
                      itemCount: lecs.length,
                      itemBuilder: (context,index){
                      
                      return ListTile(
                      
                        title:
                          Card(child: 
                          InkWell(
                            onTap: (){},
                            child: Container(
                              height: 50,
                              width: 100,
                              child: Row(
                                children: [
                                  SizedBox(width: 50,),
                                  Container(
                                    width: 550,
                                    child: Text("${lecs.elementAt(index).nom} ${lecs.elementAt(index).prenom}")),
                                  Text("Date d'entrée ${lecs.elementAt(index).date_entree.day}-${lecs.elementAt(index).date_entree.month}-${lecs.elementAt(index).date_entree.year}    ${lecs.elementAt(index).nb_prets } prets"),
                                  SizedBox(width: 50,),
                                  RatingBar.builder(
   initialRating: (lecs.elementAt(index).fidelite).toDouble(),
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: (rating) {
     return;
   },)
                                ],
                              ))),
                          ),
                        
                        
                      );
                    });
                }
              )),]),
      ),);
            }
          
        
      
      
    
  }
