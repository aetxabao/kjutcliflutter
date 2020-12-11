import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'buttons_screen.dart';

class SettingsScreen extends StatefulWidget {
  String title;
  Socket socket;

  SettingsScreen({Key key, @required this.title, @required this.socket})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _ip1Controller = TextEditingController();
  final TextEditingController _ip2Controller = TextEditingController();
  final TextEditingController _ip3Controller = TextEditingController();
  final TextEditingController _ip4Controller = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String ip = GetStorage().read("ip");
    if (ip != null) {
      final a = ip.split(".");
      print(a);
      _ip1Controller.text = a[0];
      _ip2Controller.text = a[1];
      _ip3Controller.text = a[2];
      _ip4Controller.text = a[3];
    }
    String port = GetStorage().read("port");
    if (port != null) _portController.text = port;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: _body());
  }

  Widget _body() {
    final w = 80.0;
    final f = 32.0;
    final h = 30.0;
    return Builder(
      builder: (ctx) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: w,
                  child: TextField(
                    controller: _ip1Controller,
                    decoration: InputDecoration(
                      hintText: "X",
                      counterText: "",
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: f, // This is not so important
                    ),
                    maxLength: 3,
                  ),
                ),
                Text("."),
                Container(
                  width: w,
                  child: TextField(
                    controller: _ip2Controller,
                    decoration: InputDecoration(
                      hintText: "X",
                      counterText: "",
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: f, // This is not so important
                    ),
                    maxLength: 3,
                  ),
                ),
                Text("."),
                Container(
                  width: w,
                  child: TextField(
                    controller: _ip3Controller,
                    decoration: InputDecoration(
                      hintText: "X",
                      counterText: "",
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: f, // This is not so important
                    ),
                    maxLength: 3,
                  ),
                ),
                Text("."),
                Container(
                  width: w,
                  child: TextField(
                    controller: _ip4Controller,
                    decoration: InputDecoration(
                      hintText: "X",
                      counterText: "",
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: f, // This is not so important
                    ),
                    maxLength: 3,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: h,
            ),
            Container(
              width: 2 * w,
              child: TextField(
                controller: _portController,
                decoration: InputDecoration(
                  hintText: "XXXXX",
                  counterText: "",
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: f, // This is not so important
                ),
                maxLength: 5,
              ),
            ),
            SizedBox(
              height: h,
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _settings(ctx),
            ),
          ],
        ),
      ),
    );
  }

  _settings(context) async {
    String ip = _ipAddress();
    int port = _portNumber();
    String errorMsg = null;
    if (ip == null) {
      errorMsg = "Configuración IP";
    } else if (port == 0) {
      errorMsg = "Configuración de puerto";
    } else {
      try {
        widget.socket =
            await Socket.connect(ip, port, timeout: Duration(seconds: 3));
        GetStorage().write("ip", ip);
        GetStorage().write("port", _portController.text);
        Get.offAll(ButtonsScreen(
          title: widget.title,
          socket: widget.socket,
        ));
      } catch (e) {
        errorMsg = "No se puede conectar.";
      }
    }
    if (errorMsg != null) {
      Alert(
        context: context,
        title: "ERROR",
        desc: "No se puede conectar.",
        image: Image.asset("assets/images/face0.png"),
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }

  String _ipAddress() {
    int i1, i2, i3, i4;
    try {
      i1 = int.parse(_ip1Controller.text);
      i2 = int.parse(_ip2Controller.text);
      i3 = int.parse(_ip3Controller.text);
      i4 = int.parse(_ip4Controller.text);
    } catch (Exception) {
      return null;
    }
    if (i1 < 0 ||
        i1 > 255 ||
        i2 < 0 ||
        i2 > 255 ||
        i3 < 0 ||
        i3 > 255 ||
        i4 < 0 ||
        i4 > 255) return null;
    return "$i1.$i2.$i3.$i4";
  }

  int _portNumber() {
    int p;
    try {
      p = int.parse(_portController.text);
    } catch (Exception) {
      return 0;
    }
    if (p < 1 || p > 64535) return 0;
    return p;
  }
}
