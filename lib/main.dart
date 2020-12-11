import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket/screen/buttons_screen.dart';
import 'package:socket/screen/settings_screen.dart';

void main() async {
  Socket socket;
  await GetStorage.init();
  String ip = GetStorage().read("ip");
  String port = GetStorage().read("port");
  try {
    socket = await Socket.connect(ip, int.parse(port),
        timeout: Duration(seconds: 3));
  } catch (SocketException) {
    socket = null;
  }
  runApp(MyApp(socket));
}

class MyApp extends StatelessWidget {
  Socket socket;

  MyApp(Socket s) {
    this.socket = s;
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Kjut client';
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: socket == null
          ? SettingsScreen(
              title: title,
              socket: socket,
            )
          : ButtonsScreen(
              title: title,
              socket: socket,
            ),
    );
  }
}
