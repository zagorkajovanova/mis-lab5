// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lab_mis/screens/signin_screen.dart';
import 'package:lab_mis/screens/register_screen.dart';
import 'package:lab_mis/screens/google_map_screen.dart';
import 'package:lab_mis/services/notification_service.dart';
import 'screens/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: SignInScreen.idScreen,
      routes: {
        HomeScreen.idScreen:(context) => HomeScreen(),
        SignInScreen.idScreen:(context) => SignInScreen(),
        RegisterScreen.idScreen:(context) => RegisterScreen(),
        // MapScreen.idScreen:(context) => MapScreen(),
      }
    );
  }

 
}

