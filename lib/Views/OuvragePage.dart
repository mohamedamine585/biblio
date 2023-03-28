import 'package:flutter/material.dart';
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
  List<Ouvrage> Ouvs = [] , temp = [];
   
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
                         Ouvs.clear();
                     Ouvrages?.forEach((element) {
                      if((element.nomAuteur.contains(value) || element.nomOuvrage.contains(value))
                      && ((dispofiltre && element.nb_dispo >0 ) || (pretesfiltre &&( element.nb - element.nb_dispo) > 0) || (!pretesfiltre && !dispofiltre)) )
                       {
                        
                        Ouvs.add(element);
                       } });
                         
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
                      if(dispofiltre){
                        temp = Ouvs ;
                  Ouvs = Ouvs.where((element) => element.nb_dispo>0).toList();
                      }
                      else{
                        
                        Ouvs = temp;
                      }
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
                if(pretesfiltre){
                  Ouvs = temp;
                                    print(temp.length);

                  Ouvs = Ouvs.where((element) => (element.nb - element.nb_dispo)>0).toList();
               
                }else{
                  print(temp.length);
                  Ouvs = temp;

                } if(dispofiltre){
              
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
                  return ListView.builder(
                      itemCount: Ouvs.length,
                      itemBuilder: (context,index){
               {    
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
                                            Text("${Ouvs.elementAt(index).nomOuvrage}",style: TextStyle(fontSize: 20),), 
                                            const   SizedBox(width: 50),
                                            Text(" ${Ouvs.elementAt(index).nomAuteur}"),
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
