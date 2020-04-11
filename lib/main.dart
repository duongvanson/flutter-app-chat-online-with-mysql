import 'package:famychatmysql/commons.dart';
import 'package:famychatmysql/home.dart';
import 'package:famychatmysql/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CHAT",
      home: FutureBuilder(
        future: Common.getToken(),
        builder: (context, snap){
          if (snap.hasData && snap.data!=null) {
            return HomePage();
          }  else{
            return LoginPage();
          }
        },
      ),
    );
  }
}
