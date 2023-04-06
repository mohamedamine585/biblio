 
 import 'package:flutter/material.dart';

void sd(String text , BuildContext context){
   showDialog(context: context, builder: (context){
                      return  AlertDialog(
                        title: const Text("Bibliothèque"),
                        content: Text(text),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          },child: Text("Ok"),)
                        ],
                      );
                    });
 }