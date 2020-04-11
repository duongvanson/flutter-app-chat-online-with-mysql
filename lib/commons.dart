import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Common {
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    String password = prefs.getString("password");
    String fullName = prefs.getString("full_name");
    if (username.isEmpty && password.isEmpty && fullName.isEmpty)
      return '';
    else return username + ";" + password + ";" + fullName;
  }

  static Future<void> setToken(
      String username, String password, String fullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (username.isEmpty && password.isEmpty && fullName.isEmpty) {
      prefs.remove("username");
      prefs.remove("password");
      prefs.remove("full_name");
    } else {
      prefs.setString("username", username);
      prefs.setString("password", password);
      prefs.setString("full_name", fullName);
    }
  }

  static Future<String> login(String username, String password) async {
    var res = await http.post("http://192.168.1.107/chat/api/login.php",
        body: {'username': username, 'password': password});
    if (res.statusCode == 200) {
      if (res.body != null) {
        var jsonx = json.decode(res.body);
        await setToken(jsonx['username'].toString(),
            jsonx['password'].toString(), jsonx['full_name'].toString());
      }
      return res.body;
    } else {
      return '';
    }
  }
}
