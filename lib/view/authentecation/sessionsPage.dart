import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/view/authentecation/login.dart';
import 'package:weatherapp/view/pages/homepage.dart';

class Sessions extends StatefulWidget {
  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  var timer;

  @override
  void initState() {
    timer = Timer(Duration(milliseconds: 100), () {
      _getLoginState();
    });

    super.initState();
  }

  @override
  void dispose() {
    // timer.dispose();
    super.dispose();
  }

  Future _getLoginState() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sessions = _prefs.getString('data');
    // final groupId = '0';
    // final groupName = 'Public Feeds';
    //feedsBox.put('GROUPNAME', groupName);
    //feedsBox.put('GROUPIDEACH', groupId);

    if (_sessions != null) {
      final page = HomePage(
          //  channel: IOWebSocketChannel.connect('ws://api.empl-dev.site:443'),
          );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => page));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
