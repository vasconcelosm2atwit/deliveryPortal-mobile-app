import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
import 'driver/driver_page.dart';

class HomePage extends StatefulWidget {
  //User? user;
  const HomePage({super.key});
  // setup a index per page, when button is presed change page to that index
  // in the body, so list of pages load index page

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Driver? temp;
  int pageIndex = 1;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(FirebaseAuth.instance.currentUser != null){
        Provider.of<DriverViewModel>(context, listen: false).setDriver(FirebaseAuth.instance.currentUser!.uid);

        Provider.of<DriverViewModel>(context, listen: false).getDriver();
        Provider.of<DriverViewModel>(context, listen: false).getDeliveries();
        loading = false;
        }
      else{
        print("no user");
      }
    });
    
  }

  List<Widget> _pages = [
    CompletedDeliveryPage(),
    DeliveryPage(),
    ScanDeliveryPage()
  ];


  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    //Driver drivers = Provider.of<DriverViewModel>(context).driver;
    return Scaffold(
      backgroundColor: Color(0xff0E1420) ,

      // appBar: AppBar(
      //   backgroundColor: Colors.deepPurple[300],
      //   title: Text('Home'),
      // ),
      //drawer: _drawer(),
      bottomNavigationBar: CurvedNavigationBar(
       backgroundColor: Color(0xff0E1420) ,
       index: pageIndex,
       onTap: (index) => {
         setState(() {
            pageIndex = index;
          })
       },
        
        items: [
        const Icon(Icons.home, size: 30),
        const Icon(Icons.person, size: 30),
        const Icon(Icons.settings, size: 30),
      ],
      ),
      body: SafeArea(
        child: _pages[pageIndex],
        //DeliveryPage(),
      // child: Center( // screens[index];
      //   child: vm.loading ? const CircularProgressIndicator() :
      //   Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text("Home Page ${vm.driver.name}"),
      //       Text("Hello ${vm.driver.name}"),
      //       IconButton(
      //         icon: const Icon(Icons.exit_to_app),
      //         onPressed: () {
      //           signOut();
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    )
    );
  }

  
  Widget _drawer(){
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
                child: Text('Delivery Portal', style: TextStyle(fontSize: 20),)),
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