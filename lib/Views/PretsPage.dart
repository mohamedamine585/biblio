import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/GestPret.dart';
import 'package:flutter_application_1/backend/Pret.dart';
import 'package:mysql1/mysql1.dart';




class PretsPage extends StatefulWidget {
  const PretsPage({super.key});
  @override
  State<PretsPage> createState() => _PretsPageState();
}

class _PretsPageState extends State<PretsPage> {
  List<Pret?> Prets = [];
  List<Pret> P = [],Ptemp = [];
  bool actuelfiltre = false ;
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
             Row(
              
              children: [
              const  SizedBox(width: 500,),
                Container(
                  width: 500,
                  child: TextField(
                    
                    onChanged: (value) {
                      setState(() {
                        P.clear();
                        Prets.forEach((element) { 
                          if((element!.nompersonnel.contains(value)  || (element.prenompersonnel.contains(value)) 
                        || element.nomouvrage.contains(value)  || (element.auteur.contains(value) || (element.nomlecteur.contains(value)) ||(element.prenomlecteur.contains(value)) )) )
                         {
                          Ptemp = P ;
                          if(actuelfiltre && element.termine == 0){
                            P.add(element);
                          }
                         else if(!actuelfiltre){P.add(element);
                          Ptemp = P ; 
                         }
                        
                         }
                        
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
                  ),
                ),
                const SizedBox(width: 20,),
                Text("Prets actuels :"),
                const SizedBox(width: 10,),

                 Checkbox(value: actuelfiltre, onChanged:(act){
                setState(() 
                   {  actuelfiltre = act!;
                    if(actuelfiltre){
                     P = Ptemp;
                      P =  P.where((element) => element.termine == 0).toList();
                      
                    }else{
                      print(Ptemp.length);
                      P = Ptemp ;
                    }}
                ); 
                })
              ],
            
            
            ),
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
                      bool able_to_remove = snapshot.data?.elementAt(index)?.termine == 0;
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
                                    const    SizedBox(width: 20,),

                                    able_to_remove ? IconButton(onPressed: ()async{
                                         await GestPret().delete_prets(mySqlConnection: mysqlconn, nomouvrage: P.elementAt(index).nomouvrage 
                                         , nomauteur: P.elementAt(index).auteur
                                         , nomlecteur: P.elementAt(index).nomlecteur 
                                         , prenomlecteur: P.elementAt(index).prenomlecteur
                                         , idpret: P.elementAt(index).idpret ?? -1);
                                                                                  
                                              setState(() { 
                                             build(context);
                                           });

                                      
                                           
                                    }, icon:const Icon(Icons.remove),):SizedBox(),
                                    const SizedBox(width: 50,),
                                   
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

