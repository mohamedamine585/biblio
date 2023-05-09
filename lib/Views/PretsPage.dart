
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
  List<Pret?> P = [];
  bool actuelfiltre = false ;
   String s = "";
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
                         P = Prets.where((element) => (element!.nompersonnel.contains(s)  || (element.prenompersonnel.contains(s)) 
                        || element.nomouvrage.contains(s)  || (element.auteur.contains(s) || (element.nomlecteur.contains(s)) ||(element.prenomlecteur.contains(s)) )) && (!actuelfiltre || (element.termine == 0))).toList();
    int able_to_remove ;
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
                       s = value;
                        
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
                    }
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
                     P = Prets.where((element) => pret_cherche(element?.nomlecteur ?? ""
                     , element?.prenomlecteur ?? "", element?.nomouvrage ?? "", element?.auteur ?? "", s)).toList();
                  return ListView.builder(
                      itemCount: P.length,
                      itemBuilder: (context,index){
                          int temps_pret_restant;
                      try{
                       temps_pret_restant = DateTimeRange(start: DateTime.now().toUtc(), end: (P.elementAt(index)?.fin_pret)!).duration.inDays ;

                      }catch(e){
                         temps_pret_restant = 0 ;
                      }
                       able_to_remove = P.elementAt(index)?.termine ?? 0;
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
                                        child: Text("${P.elementAt(index)?.nomouvrage} ${P.elementAt(index)?.auteur}")),
                                    ),
                                    Text("Lecteur : ${P.elementAt(index)?.nomlecteur}  ${P.elementAt(index)?.prenomlecteur}    "),
                                    
                                    Text(" Personnel : ${P.elementAt(index)?.nompersonnel}  ${P.elementAt(index)?.prenompersonnel}   "),
                                  
                                                                      Text("Debut de pret : ${P.elementAt(index)?.debut_pret.day}-${P.elementAt(index)?.debut_pret.month}-${P.elementAt(index)?.debut_pret.year}    "),

                                    able_to_remove == 0  ?   Text("  Reste : ${temps_pret_restant}" ,style: TextStyle(color: temps_pret_restant > 0 ? Colors.black : Colors.red) ,):                                  
                                   Text("Fin de pret : ${P.elementAt(index)?.fin_pret.day}-${P.elementAt(index)?.fin_pret.month}-${P.elementAt(index)?.fin_pret.year}    "),

                                    const    SizedBox(width: 20,),

                                    able_to_remove == 0 ? TextButton(onPressed: ()async{
                                     
                                      await personnel.delete_prets(mySqlConnection: mysqlconn,pret: P.elementAt(index)!);
                                     setState(() {   
                                          able_to_remove = 1 ;
                                           });
                                       
                                                                                  
                                            

                                      
                                           
                                    },
                               
                                     child:const Text("Terminer pret")): able_to_remove==1 ? const Text("Pret terminé",style: TextStyle(color: Colors.grey),) :const Text("Ouvrage Perdu",style: TextStyle(color: Color.fromARGB(255, 143, 16, 16)),) ,
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




  bool pret_cherche(String nom , String prenom , String ouvrage , String auteur , String? s){
 
 
 
 return   (nom.contains(s?.substring(s.contains( RegExp(r'#\w+'))?s.indexOf('#')+1:0) ?? "###") ||prenom.contains(s?.substring(s.contains( RegExp(r'#\w+'))?s.indexOf('#')+1:0) ?? "") || ouvrage.contains(s?.substring(0,s.contains(RegExp(r'w+\#'))?s.indexOf('#')-1:s.length ) ?? "") || auteur.contains(s?.substring(0,s.contains(RegExp(r'w+\#'))?s.indexOf('#')-1:s.length ) ?? "")
 || nom.toLowerCase().contains(s?.substring(s.contains( RegExp(r'#\w+'))?s.indexOf('#')+1:0) ?? "###") ||prenom.toLowerCase().contains(s?.substring(s.contains( RegExp(r'#\w+'))?s.indexOf('#')+1:0) ?? "") || ouvrage.toLowerCase().contains(s?.substring(0,s.contains(RegExp(r'w+\#'))?s.indexOf('#')-1:s.length)?? "") || auteur.toLowerCase().contains(s?.substring(0,s.contains(RegExp(r'w+\#'))?s.indexOf('#')-1:s.length ) ?? "") ) || s == "" || s == "#";
        



  }