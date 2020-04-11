import 'dart:convert';

import 'package:famychatmysql/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  User user;
  User userTo;

  ChatPage({this.user, this.userTo});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _ctrlMess = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userTo.fullName),
      ),
      body: StreamBuilder(
        initialData: null,
        stream: _stream(),
        builder: (context, snap) {
          if (snap.hasData) {
            var temp = snap.data as Future<List<dynamic>>;
            return Column(
              children: <Widget>[
                FutureBuilder(
                  future: temp,
                  builder: (context, snap) {
                    List<dynamic> lst = snap.data;
                    if (lst != null) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: lst.length,
                          itemBuilder: (context, index) {
                            var username = lst[index]['user'];
                            var mess = lst[index]['content'].toString();
                            return Container(
                              margin: username == widget.user.username
                                  ? EdgeInsets.only(
                                      right: 2, bottom: 5, top: 5, left: 100)
                                  : EdgeInsets.only(
                                      right: 100, bottom: 5, top: 5, left: 2),
                              padding: EdgeInsets.all(13),
                              child: Text(
                                mess,
                                textAlign: username == widget.user.username
                                    ? TextAlign.right
                                    : TextAlign.left,
                                style: TextStyle(
                                    color: username == widget.user.username
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              decoration: BoxDecoration(
                                color: username == widget.user.username
                                    ? Colors.blue[400]
                                    : Colors.blueGrey[100],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
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
                ),
                Divider(
                  color: Colors.blueAccent,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: _ctrlMess,
                      decoration: new InputDecoration.collapsed(
                          hintText: "Nhập gì đi..."),
                    )),
                    Container(
                      child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            String content = _ctrlMess.text.trim();
                            if (content.isNotEmpty) {
                              var res = await _sendMess(content);
                              print(res);
                              _ctrlMess.text="";
                            } else {
                              print("empty");
                            }
                          }),
                    )
                  ],
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Stream<Future<List<dynamic>>> _stream() {
    Duration interval = Duration(seconds: 1);
    Stream<Future<List<dynamic>>> stream =
        Stream<Future<List<dynamic>>>.periodic(interval, _getData);
    return stream;
  }

  Future<List<dynamic>> _getData(int value) async {
    var res =
        await http.post('http://192.168.1.107/chat/api/get_mess.php', body: {
      'username': widget.user.username,
      'password': widget.user.password,
      'user_to': widget.userTo.username
    });
    var jsonx = json.decode(res.body);
    return jsonx;
  }

  _sendMess(String content) async {
    var res =
        await http.post('http://192.168.1.107/chat/api/send_mess.php', body: {
      'username': widget.user.username,
      'password': widget.user.password,
      'user_to': widget.userTo.username,
      'content': content
    });
    return res.body;
  }
}
