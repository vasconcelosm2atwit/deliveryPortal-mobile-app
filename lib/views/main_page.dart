// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:deliveryportal_driver_app/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/driver_view_model.dart';
import 'home_page.dart';
import 'home_page2.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverViewModel>.value(
        value: DriverViewModel(),
        child: Scaffold(
            body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasData) {
                      return HomePage2();
                    } else {
                      return LoginPage();
                    }
                  }
                })));
  }
}
