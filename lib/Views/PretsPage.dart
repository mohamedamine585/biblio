import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/GestLecteur.dart';
import 'package:flutter_application_1/backend/GestPret.dart';
import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:flutter_application_1/backend/Pret.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mysql1/mysql1.dart';




class PretsPage extends StatefulWidget {
  const PretsPage({super.key});

  @override
  State<PretsPage> createState() => _PretsPageState();
}

class _PretsPageState extends State<PretsPage> {
  List<Pret?> Prets = [];
  List<Pret> P = [];
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
        title:const Center(child: Text("Prets")),
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
                  P.clear();
                  Prets.forEach((element) { 
                    if(element!.nompersonnel.contains(value)  || (element.prenompersonnel.contains(value)) 
                  || element.nomouvrage.contains(value)  || (element.auteur.contains(value) || (element.nomlecteur.contains(value)) ||(element.prenomlecteur.contains(value)) ))
                   P.add(element);
                  
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
                future: GestPret().get_prets(mySqlConnection: mysqlconn),
                builder: (context, snapshot) {
                   Prets = snapshot.data ?? []  ;

                  return ListView.builder(
                      itemCount: P.length,
                      itemBuilder: (context,index){
                      final temps_pret_restant = DateTimeRange(start: DateTime.now().toUtc(), end: P.elementAt(index).fin_pret).duration.inDays ;
                      
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
                                        child: Text("${P.elementAt(index).nomouvrage} ${P.elementAt(index).auteur}")),
                                    ),
                                    Text("Lecteur : ${P.elementAt(index).nomlecteur}  ${P.elementAt(index).prenomlecteur}    "),
                                    
                                    Text("Date de pret : ${P.elementAt(index).debut_pret.day}-${P.elementAt(index).debut_pret.month}-${P.elementAt(index).debut_pret.year}    "),
                                    Text(" Personnel : ${P.elementAt(index).nompersonnel}  ${P.elementAt(index).prenompersonnel}"),
                                  
                                    Text("  Reste : ${temps_pret_restant}" ,style: TextStyle(color: temps_pret_restant > 0 ? Colors.black : Colors.red),),
                                    SizedBox(width: 50,),
                                   
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
