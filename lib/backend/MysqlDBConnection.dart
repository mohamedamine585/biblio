import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';

class MysqlConn {
  Future<MySqlConnection?> get_connection() async{
  try{   var settings =  ConnectionSettings(
    host: '127.0.0.1',
        port: 3306,
        user: 'root',
        password: 'kiluathunder123@456',
        db: 'injapp'
     );
     
     final conn =await MySqlConnection.connect(settings);
   

    return conn;}
    catch(e){
      log(e.toString());
      return null;
    }
  }
}