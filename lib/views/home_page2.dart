// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:deliveryportal_driver_app/views/completed_page.dart';
import 'package:deliveryportal_driver_app/views/deliveries/deliveries.dart';
import 'package:deliveryportal_driver_app/views/scan_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/driver_model.dart';
import '../services/auth.dart';
import '../view_model/driver_view_model.dart';
import 'deliveries/CurrentDelivery.dart';
import 'driver/driver_page.dart';
import 'widgets/settings_page.dart';

class HomePage2 extends StatefulWidget {
  //User? user;
  const HomePage2({super.key});
  // setup a index per page, when button is presed change page to that index
  // in the body, so list of pages load index page

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  Driver? temp;
  int pageIndex = 1;
  bool loading = true;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null) {
        Provider.of<DriverViewModel>(context, listen: false)
            .setDriver(FirebaseAuth.instance.currentUser!.uid);

        Provider.of<DriverViewModel>(context, listen: false).getDriver();
        Provider.of<DriverViewModel>(context, listen: false).getDeliveries();
        loading = false;
      } else {
        print("no user");
      }
    });
  }

  final List<Widget> _pages = [
    const CurrentDeliveryPage(),
    const DeliveryPage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    //Driver drivers = Provider.of<DriverViewModel>(context).driver;
    return Scaffold(
        backgroundColor: const Color(0xff080613),
        bottomNavigationBar: CustomNavigationBar(
          iconSize: 30.0,
          selectedColor: const Color.fromARGB(255, 107, 88, 163),
          strokeColor: Colors.white,
          unSelectedColor: const Color(0xffacacac),
          backgroundColor: Colors.transparent,
          //isFloating: true,
          borderRadius: const Radius.circular(10),
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          currentIndex: pageIndex,
          items: [
            CustomNavigationBarItem(icon: const Icon(Icons.home)),
            CustomNavigationBarItem(
              icon: const Icon(Icons.search),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.settings),
            ),
          ],

          // backgroundColor: Colors.white,
          // items: [
          //   CustomNavigationBarItem(
          //     icon: Icon(Icons.home)),
          //   CustomNavigationBarItem(
          //     icon: Icon(Icons.shopping_cart),
          //   ),
          //   CustomNavigationBarItem(
          //     icon: Icon(Icons.lightbulb_outline),
          //   ),
          //   CustomNavigationBarItem(
          //     icon: Icon(Icons.search),
          //   ),
          //   CustomNavigationBarItem(
          //     icon: Icon(Icons.account_circle),
          //   ),
          // ],
        ),
        // CurvedNavigationBar(
        //   backgroundColor: const Color(0xff0E1420),
        //   index: pageIndex,
        //   onTap: (index) => {
        //     setState(() {
        //       pageIndex = index;
        //     })
        //   },
        //   items: const [
        //     Icon(Icons.home, size: 30),
        //     Icon(Icons.person, size: 30),
        //     Icon(Icons.settings, size: 30),
        //   ],
        // ),
        body: SafeArea(
          child: _pages[pageIndex],
        ));
  }

  Widget _drawer() {
    return Drawer(
      child: Container(
        color: Colors.deepPurple[300],
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  //color: Colors.blue,
                  ),
              child: Center(
                  child: Text(
                'Delivery Portal',
                style: TextStyle(fontSize: 20),
              )),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
