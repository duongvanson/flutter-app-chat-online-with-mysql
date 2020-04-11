import 'package:famychatmysql/commons.dart';
import 'package:famychatmysql/home.dart';
import 'package:famychatmysql/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _ctrlUsername = new TextEditingController();
  TextEditingController _ctrlPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("HELLO"),
          TextField(
            controller: _ctrlUsername,
            decoration: InputDecoration(labelText: "Username"),
          ),
          TextField(
            controller: _ctrlPassword,
            decoration: InputDecoration(labelText: "Password"),
          ),
          MaterialButton(
            child: Text("Login"),
            color: Colors.blue,
            onPressed: () async {
              var res = await Common.login(
                  _ctrlUsername.text.toString(), _ctrlPassword.text.toString());
              if (res != null) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyApp()));
              }
            },
          )
        ],
      ),
    );
  }
}
