import 'package:flutter/material.dart';
import 'package:inotebook/layouts/home.dart';
import 'package:inotebook/layouts/login.dart';

void main() {
  runApp( MaterialApp(
    title: 'Login Page',
    routes:{
      '/': (context)=>Login(),
      '/Home': (context) =>Home(),
      '/Favs': (context)=>Home()
    },
  ));
}
