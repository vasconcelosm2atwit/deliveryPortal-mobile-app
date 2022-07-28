import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../services/auth_service.dart';
import '../../services/custom_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: CustomText(text: "Settings", color: Colors.white),
            ),
          ),
          Card(
              elevation: 2.0,
              color: Colors.white,
              child: ListTile(
                title: Text('About'),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
          Card(
              elevation: 2.0,
              color: Colors.white,
              child: ListTile(
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
          Card(
              elevation: 2.0,
              color: Colors.white,
              child: ListTile(
                title: Text('Logout'),
                onTap: () {
                  _authService.signOut();
                  //Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}
