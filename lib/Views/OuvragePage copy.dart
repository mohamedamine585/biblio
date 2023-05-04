


import 'package:flutter/material.dart';
import 'package:flutter_application_1/Consts.dart';
import 'package:flutter_application_1/backend/Ouvrage.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';


class OuvrageMqperdpage extends StatefulWidget {
  const OuvrageMqperdpage({super.key});

  @override
  State<OuvrageMqperdpage> createState() => _OuvrageMqperdpageState();
}

class _OuvrageMqperdpageState extends State<OuvrageMqperdpage> {
  bool dispofiltre = false ,pretesfiltre = false ; 
  List<Ouvrage>? Ouvrages = [];
   String ?q ;
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

      List<Ouvrage> Ouvs;
    final data =  ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final personnel = data[0] as Personnel ;
    final mysqlconn = data[1]as MySqlConnection ;
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: Text("Ouvrages Perdus")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          const SizedBox(height :50) ,
            Row(
              
              children: [ 
              const  SizedBox(width: 300 ),
                Container(
                  width: 600,
                child:
                    TextField(
                      
                      onChanged: (value) {
                        
                      setState(() {
                        q = value;
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
                    ),
                  
                ),
                
              ],
            ),
           const SizedBox(height: 100,),
            Container(

              height: 630,
              child: FutureBuilder(
                future: personnel.get_Ouvrages_Mq_perdus(mySqlConnection: mysqlconn),
                builder: (context, snapshot) {
                   Ouvrages = snapshot.data  ;
                   Ouvs = Ouvrages?.where((element) => (element.nomAuteur.contains(q ?? '') || element.nomOuvrage.contains(q ?? ''))
                   ).toList() ?? [] ;
                  return ListView.builder(
                      itemCount: Ouvs.length,
                      itemBuilder: (context,index){
               {    
                      return ListTile(
                      
                        title:
                          Card(child: 
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamedAndRemoveUntil(modouvrage, (route) => false);
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              child: SingleChildScrollView(
                                child: Row(
                                  children: [
                                   const SizedBox(width: 50,),
                                    SingleChildScrollView(
                                      child: Container(
                                        width: 500,
                                        child: Row(
                                          children: [
                                            Text("${Ouvs.elementAt(index).nomOuvrage}",style: TextStyle(fontSize: 20),softWrap: true,), 
                                            const   SizedBox(width: 50),
                                            Text(" ${Ouvs.elementAt(index).nomAuteur}",softWrap: true,),
                                          ],
                                       )) ),
                                    Container(
                                      width: 450,
                                      child: Row(
                                        children: [
                                          
                                          Text("    Nombre de livres : ${Ouvs.elementAt(index).nb}" ), 
                                      const SizedBox(width: 20,),
                                      Text("${Ouvs.elementAt(index).nb - Ouvs.elementAt(index).nb_dispo } prets "),
                                      const SizedBox(width: 30,),
                                       Text("nombre de copies perdues :  ${Ouvs.elementAt(index).nb_perdu }"),
                                       
                                        ],
                                      ),
                                    ) ,
                                    
                                    Text("Date d'entrée : ${Ouvs.elementAt(index).date_entree.day}-${Ouvs.elementAt(index).date_entree.month}-${Ouvs.elementAt(index).date_entree.year}    "),
                                  
                                    SizedBox(width: 50,),
                                   TextButton(onPressed: ()async{
                                    final deleted = await personnel.supprimer_ouvrage(mySqlConnection: mysqlconn, ouvrage: Ouvs.elementAt(index));
                                    if(deleted){
                                     setState(() {
                                       Ouvs.remove(Ouvs.elementAt(index));
                                     });
                                    }
                                   }, child: const Text("supprimer l'ouvrage"))
                                  ],
                                ),
                              ))),
                          ),
                        
                        
                      );}
                    });
                }
              )),
          
              ]),
              
      ),);
            }
          
        
      
      
    
  }
