import 'package:flutter/material.dart';
import 'package:flutter_application_1/Consts.dart';
import 'package:flutter_application_1/backend/MysqlDBConnection.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override 
  final mysqlconn = MysqlConn();
  final GestP = Personnel();
  @override
  Widget build(BuildContext context) {
    final route_data = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final user = route_data[0] as Personnel;
    final mysqlconn = route_data[1] as MySqlConnection;
   
        return Scaffold(
          
          appBar: AppBar(
             actions: [
              IconButton(onPressed: (){
                if(user.grade == 'president') {
                  Navigator.of(context).pushNamed(AjouPersView,arguments:[user, mysqlconn]);
                }
              }, icon: Icon(Icons.person_add)),
              SizedBox(width: 10,),
              IconButton(onPressed: (){},icon: Icon(Icons.person_remove_alt_1)),
              SizedBox(width: 10,),
              IconButton(onPressed: ()async{
                   await GestP.logout(mysqlconn);
                   Navigator.of(context).pushNamedAndRemoveUntil(AuthenView, (route) => false);
              },icon:  Icon(Icons.logout),),
              
             ],
            title: Row(
              children: [
                SizedBox(width:  20,),
                Text('Bibliothèque'),
              ],
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 
                   SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
    
                     child: Row(children: [
                        
                      Card(
                        elevation: 5,
                        child: InkWell(child: Container(height: 200,
                        width: 200,child:
                         Column(
                             children: const [
                              SizedBox(height: 50,),
                              Icon(Icons.person,size: 50,),
                               Text("Lecteurs",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                             ],
                           ),
                        ),
                       onTap: (){
                        Navigator.of(context).pushNamed(LecteurPage,arguments:[user,mysqlconn]);
                       },
                                 
                        ),
                        ),
                        SizedBox(width: 50,),
                         Card(  
                          elevation: 5,           
                         child: Container(height: 200,
                        width: 200,child: InkWell(
                          
                           child: Column(
                             children: const [
                              SizedBox(height: 50,),
                              Icon(Icons.book,size: 50,),
                               Text("Ouvrages",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                             ],
                           ),
                           onTap: (){
                            Navigator.of(context).pushNamed(OuvragePage,arguments:[user,mysqlconn]);
                           },
                         ),
                        ),),
                        SizedBox(width: 50,),
                      Card(     
                        elevation: 5,
                                   child: Container(height: 200,
                        width: 200,child:
                      InkWell(
                        child: Column(
                             children: const[
                              SizedBox(height: 50,),
                              Icon(Icons.send_outlined,size: 50,),
                               Text("Prêts",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                             ],
                           ),
                           onTap: (){
                            Navigator.pushNamed(context, PretPage,arguments: [user,mysqlconn]);
                           },
                      ),
                        ),),
                     ],),
                   ),
                
                SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
    
                  child: Row(children: [
                      Card(     
                        elevation: 5, 
                                  child: Container(height: 200,
                        width: 200,child:InkWell(
                                    child: Column(
                                                     children: const [
                                                      SizedBox(height: 50,),
                                                      Icon(Icons.person_add_alt,size: 50,),
                                                       Text("Ajouter Lecteur ",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                                                     ],
                                                   ),
                                                   onTap: (){
                                                     Navigator.of(context).pushNamed(AjouLecView,arguments:[user, mysqlconn]);
                                                   },
                                  ),
                        ),),
                        SizedBox(width: 50,),
                      Card(     
                        elevation: 5,
                                   child: Container(height: 200,
                        width: 200,child: InkWell(
                        child: Column(
                             children:const [
                              SizedBox(height: 50,),
                              Icon(Icons.bookmark_add,size: 50,),
                               Text("Ajouter Ouvrage",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                             ],
                           ),
                           onTap: (){
                            Navigator.of(context).pushNamed(AjouOuvView,arguments:[user, mysqlconn]);
                           },
                      ),
                        ),),
                        SizedBox(width: 50,),
                      Card(     elevation: 5,
                                   child: Container(height: 200,
                        width: 200,child: InkWell(
                        child: Column(
                             children:const [
                              SizedBox(height: 50,),
                              Icon(Icons.bookmark_add_outlined,size: 50,),
                               Text("Ajouter prêt",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                             ],
                           ),
                           onTap: (){
                            Navigator.of(context).pushNamed(AjouPretView,arguments: [mysqlconn,user]);
                           },
                      ),
                        ),),
                     ],),
                ), SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [                    
                      Card(       elevation: 5,
                                 child: Container(height: 200,
                        width: 200,child:InkWell(
                        child: Column(
                             children: const[
                              SizedBox(height: 50,),
                              Icon(Icons.person_off,size: 50,),
                               Text("Exclure Lecteur",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                             ],
                           ),
                      ),
                        ),),
                                         SizedBox(width: 50,),
                        
                      Card(       elevation: 5,
                                 child: Container(height: 200,
                        width: 200,child:InkWell(
                        child: Column(
                             children: const[
                              SizedBox(height: 50,),
                              Icon(Icons.book_online,size: 50,),
                               Text("Ouvrages Perdus",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                             ],
                           ),
                      ),
                        ),),
                                         SizedBox(width: 50,),
                        
                      Card(        elevation: 5,
                                child: Container(height: 200,
                        width: 200,child: InkWell(
                        child: Column(
                             children: const[
                              SizedBox(height: 50,),
                              Icon(Icons.percent,size: 50,),
                               Text("Stats",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black,fontSize: 20),),
                             ],
                           ),
                      ),
                        ),),
                     ],),
                ),
                ],
              ),
            ),
          ),
          
        );
      }
  
  
}
