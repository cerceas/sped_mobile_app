

import 'package:mysql1/mysql1.dart';

class DBconnect{
  static String host = "10.0.2.2",
  user="root",
  password="",
  db="db_aims";
  static int port =3306;
  DBconnect();

  Future<List<dynamic>> getConnection() async{
    var settings = await MySqlConnection.connect(ConnectionSettings(
      host: host,
      port:port,
      user: user,
      password: password,
      db: db
    ));
    var results = await settings.query('SELECT * FROM admin');

    return results.toList();
  }
}