import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:socket/screen/settings_screen.dart';

class ButtonsScreen extends StatefulWidget {
  final String title;
  Socket socket;

  ButtonsScreen({Key key, @required this.title, @required this.socket})
      : super(key: key);

  @override
  _ButtonsScreenState createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  final String ip = GetStorage().read("ip");
  final int port = int.parse(GetStorage().read("port"));

  @override
  Widget build(BuildContext context) {
    // Desconexión del socket
    try {
      widget.socket.close();
    } catch (e) {}
    widget.socket.close();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.offAll(SettingsScreen(
                title: widget.title,
                socket: widget.socket,
              ));
            },
          )
        ],
      ),
      body: Center(child: OrientationBuilder(builder: (context, orientation) {
        return (orientation == Orientation.portrait)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buttonsList(context),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buttonsList(context),
              );
      })),
    );
  }

  Future<void> _sendMessage(context, v) async {
    try {
      widget.socket =
          await Socket.connect(ip, port, timeout: Duration(seconds: 3));
      widget.socket.write(v);
      widget.socket.close();
      Alert(
        context: context,
        title: "Valor " + v + " enviado",
        image: Image.asset("assets/images/face" + v + ".png"),
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
    } catch (e) {
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
      return;
    }
  }

  @override
  void dispose() {
    widget.socket.close();
    super.dispose();
  }

  List<Widget> _buttonsList(context) {
    final s = RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(18.0),
      side: BorderSide(color: Colors.black),
    );
    final g = 50.0, h = 150.0, w = 150.0, f = 80.0;
    return [
      MaterialButton(
        height: h,
        minWidth: w,
        shape: s,
        color: Colors.redAccent,
        textColor: Colors.black,
        child: new Text(
          "0",
          style: TextStyle(fontSize: f),
        ),
        onPressed: () => _sendMessage(context, "0"),
        splashColor: Colors.redAccent,
      ),
      SizedBox(
        height: g,
        width: g,
      ),
      MaterialButton(
        height: h,
        minWidth: w,
        shape: s,
        color: Colors.yellow,
        textColor: Colors.black,
        child: new Text(
          "1",
          style: TextStyle(fontSize: f),
        ),
        onPressed: () => _sendMessage(context, "1"),
        splashColor: Colors.yellow,
      ),
      SizedBox(
        height: g,
        width: g,
      ),
      MaterialButton(
        height: h,
        minWidth: w,
        shape: s,
        color: Colors.green,
        textColor: Colors.black,
        child: new Text(
          "2",
          style: TextStyle(fontSize: f),
        ),
        onPressed: () => _sendMessage(context, "2"),
        splashColor: Colors.green,
      ),
    ];
  }
}
