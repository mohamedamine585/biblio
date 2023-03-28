import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
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
      final data =  ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final personnel = data[0] as Personnel ;
    final mysqlconn = data[1]as MySqlConnection ;
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child: Text("Prets")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const  SizedBox(height: 30,),

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
                        const  SizedBox(height: 30,),
            Container(
              height: 630,
              child: FutureBuilder(
                future: personnel.get_prets(mySqlConnection: mysqlconn),
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
                                    
                                    Text(" Personnel : ${P.elementAt(index).nompersonnel}  ${P.elementAt(index).prenompersonnel}   "),
                                  
                                                                      Text("Debut de pret : ${P.elementAt(index).debut_pret.day}-${P.elementAt(index).debut_pret.month}-${P.elementAt(index).debut_pret.year}    "),

                                    able_to_remove ?   Text("  Reste : ${temps_pret_restant}" ,style: TextStyle(color: temps_pret_restant > 0 ? Colors.black : Colors.red),):                                  
                                   Text("Fin de pret : ${P.elementAt(index).fin_pret.day}-${P.elementAt(index).fin_pret.month}-${P.elementAt(index).fin_pret.year}    "),

                                    const    SizedBox(width: 20,),

                                    able_to_remove ? TextButton(onPressed: ()async{

                                         await personnel.delete_prets(mySqlConnection: mysqlconn,pret: P.elementAt(index));
                                                                                  
                                              setState(() {  
                                             P.elementAt(index).termine = 1;
                                             build(context);
                                           });

                                      
                                           
                                    },
                               
                                     child:const Text("Terminer pret")):const Text("Pret terminé",style: TextStyle(color: Colors.grey),),
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

