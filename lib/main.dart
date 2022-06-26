import 'package:deliveryportal_driver_app/views/home_page.dart';
import 'package:deliveryportal_driver_app/views/login.dart';
import 'package:deliveryportal_driver_app/views/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => MainPage(),
      //   '/home': (context) => HomePage(),
      //   '/auth': (context) => LoginPage(),
      // },
      debugShowCheckedModeBanner: false,
      home: MainPage()
    );
  }
}