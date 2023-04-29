
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/Lecteur.dart';
import 'package:mysql1/mysql1.dart';

import '../Consts.dart';
import '../backend/Ouvrage.dart';

void ouvragedelaidep(Lecteur lecteur , BuildContext context , MySqlConnection mySqlConnection){
  showDialog(context: context, builder:(context){
     return  
        Dialog(
         
          child: Container(
            height: 700,
            width: 700,
            child: FutureBuilder
            (
              future: lecteur.get_Ouvrages_delai_dep(mySqlConnection: mySqlConnection),
              builder: (context,snapshot){
                List<Ouvrage>? Ouvs = snapshot.data ;
                
                 return ListView.builder(
                  itemCount: Ouvs?.length,
                  itemBuilder: (context,index){
                   
                    return ListTile(
                        title:   Card(child: 
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pushNamed(modouvrage,arguments: [Ouvs?.elementAt(index),mySqlConnection]);
                                },
                                child: Container(
                                  height: 70,
                                  width: 600,
                             
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10,),
                                        SingleChildScrollView(
                                          child: Container(
                                            width: 600,
                                            child: Row(
                                              children: [
                                                Icon(Icons.book),
                                                Container(child: Text("      ${Ouvs?.elementAt(index).nomOuvrage}",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),softWrap: true,),width: 300,), 
                                                Container(child: Text("By :"),width: 30,),
                                                Container(child: Text(" ${Ouvs?.elementAt(index).nomAuteur}",style: TextStyle(fontWeight: FontWeight.bold),softWrap: true,),width: 200,),
                                              ],
                                           )) ),
               
                                       
                                                                  
                                      
                                      ],
                                    
                                  ))),
                              ),
                    );
               
                 });
            }),
          ),
     
       );
     
    
  } );
}