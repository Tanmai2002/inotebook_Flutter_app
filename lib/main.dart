import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inotebook/layouts/home.dart';
import 'package:inotebook/layouts/login.dart';
AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);
void main() {
  _getAndroidOptions();
  runApp( MaterialApp(
    title: 'Login Page',
    initialRoute: '/',
    routes:{
      '/': (context)=>Login(),
      '/Home': (context) =>Home(),
      '/Favs': (context)=>Home()
    },
  ));
}
