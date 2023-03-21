import 'dart:developer';

import 'package:mysql1/mysql1.dart';

class MysqlConn {
  Future<MySqlConnection?> get_connection() async{
  try{   var settings = new ConnectionSettings(
        port: 3306,
        user: 'root',
        password: 'kiluathunder123@456',
        db: 'injapp'
     );
     var conn = await MySqlConnection.connect(settings);
    return conn;}
    catch(e){
      log(e.toString());
      return null;
    }
  }
}