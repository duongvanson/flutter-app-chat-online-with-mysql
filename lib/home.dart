import 'dart:convert';

import 'package:famychatmysql/chat.dart';
import 'package:famychatmysql/commons.dart';
import 'package:famychatmysql/main.dart';
import 'package:famychatmysql/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await Common.setToken('', '', '');
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              })
        ],
      ),
      body: FutureBuilder(
        future: Common.getToken(),
        builder: (context, snap) {
          if (snap.hasData && snap.data != null) {
            user = snap.data.toString().split(';');
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                      child: Text(
                    "Hello, ${user[2]}",
                    style: TextStyle(fontSize: 31, color: Colors.blue),
                  )),
                ),
                StreamBuilder(
                  stream: _stream(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      var temp = snap.data as Future<List<dynamic>>;
                      return FutureBuilder(
                        future: temp,
                        builder: (context, snap) {
                          List<dynamic> lst = snap.data;
                          if (lst != null) {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: lst.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.perm_identity),
                                    title: Text(
                                        lst[index]['full_name'].toString()),
                                    subtitle:
                                        Text(lst[index]['username'].toString()),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                  user: User(user[0], user[1],
                                                      user[2]),
                                                  userTo: User(
                                                      lst[index]['username']
                                                          .toString(),
                                                      "",
                                                      lst[index]['full_name']
                                                          .toString()))));
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            );
          } else {
            return Text("Fail");
          }
        },
      ),
    );
  }

  Stream<Future<List<dynamic>>> _stream() {
    Duration interval = Duration(seconds: 1);
    Stream<Future<List<dynamic>>> stream =
        Stream<Future<List<dynamic>>>.periodic(interval, _getUser);
    return stream;
  }

  Future<List<dynamic>> _getUser(int value) async {
    var res = await http.post('http://192.168.1.107/chat/api/get_user.php',
        body: {'username': user[0].toString()});
    var jsonx = json.decode(res.body);
    return jsonx;
  }
}
