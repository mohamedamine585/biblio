import 'package:flutter/material.dart';
import 'package:flutter_application_1/Consts.dart';
import 'package:flutter_application_1/backend/Ouvrage.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';


class Ouvragepage extends StatefulWidget {
  const Ouvragepage({super.key});

  @override
  State<Ouvragepage> createState() => _OuvragepageState();
}

class _OuvragepageState extends State<Ouvragepage> {
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
        title:const Center(child: Text("Ouvrages")),
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
                  const SizedBox(width: 15,),
             const  Text("Disponible"),
                Checkbox(value: dispofiltre, onChanged: (disp){
                setState(() {
                      dispofiltre = disp!;
                   
                      if(pretesfiltre)
                      {
                        pretesfiltre = !pretesfiltre;
                      }
                });
                }),
                  const SizedBox(width: 15,),
              const Text("Pretés"),
                Checkbox(value: pretesfiltre, onChanged: (pret){
               setState(() {
                pretesfiltre = pret! ;
                if(dispofiltre){
              
                  dispofiltre = !dispofiltre;
                }
               
               });  
                }),
              ],
            ),
           const SizedBox(height: 100,),
            Container(
              height: 630,
              child: FutureBuilder(
                future: personnel.get_Ouvrages(mySqlConnection: mysqlconn),
                builder: (context, snapshot) {
                   Ouvrages = snapshot.data  ;
                   Ouvs = Ouvrages?.where((element) => (element.nomAuteur.contains(q ?? '') || element.nomOuvrage.contains(q ?? ''))
                      && ((dispofiltre && element.nb_dispo >0 ) || (pretesfiltre &&( element.nb - element.nb_dispo) > 0) || (!pretesfiltre && !dispofiltre))
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
                              Navigator.of(context).pushNamed(modouvrage,arguments: [Ouvs.elementAt(index),mysqlconn]);
                            },
                            child: Container(
                              height: 70,
                              width: 100,
                              child: SingleChildScrollView(
                                child: Row(
                                  children: [
                                    SizedBox(width: 50,),
                                    SingleChildScrollView(
                                      child: Container(
                                        width: 700,
                                        child: Row(
                                          children: [
                                            Icon(Ouvs.elementAt(index).nb_dispo > 0? Icons.book:Icons.book_sharp,size: 60,),
                                            Container(child: Text("      ${Ouvs.elementAt(index).nomOuvrage}",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),width: 350,), 
                                            Container(child: Text("By :"),width: 50,),
                                            Container(child: Text(" ${Ouvs.elementAt(index).nomAuteur}",style: TextStyle(fontWeight: FontWeight.bold)),width: 200,),
                                          ],
                                       )) ),

                                    Container(
                                      width: 350,
                                      child: Row(
                                        children: [
                                          Text("Nombre de livres : ${Ouvs.elementAt(index).nb}" ), 
                                      const SizedBox(width: 20,),
                                      Text("${Ouvs.elementAt(index).nb - Ouvs.elementAt(index).nb_dispo } prets "),
                                      const SizedBox(width: 30,),
                                       Text("${Ouvs.elementAt(index).categorie ??  ' ' }"),
                                       
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
              )),]),
      ),);
            }
          
        
      
      
    
  }
