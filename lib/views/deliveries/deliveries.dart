import 'package:deliveryportal_driver_app/views/deliveries/widgets/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../models/delivery_model.dart';
import '../../view_model/driver_view_model.dart';
import 'widgets/delivery_content.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  bool loading = false;
  // @override
  void initState() {
    super.initState();
    
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //     Provider.of<DriverViewModel>(context, listen: false).getDeliveries();
    //     loading = false;
    // });

   // print(Provider.of<DriverViewModel>(context).deliveryList);
    
  }
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return 
    
    Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            TopBar()
            // SliverAppBar(
            //   backgroundColor: Colors.blueAccent,
            //   expandedHeight: 200.0,
            //   floating: true,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.only(
            //           bottomLeft: Radius.circular(25),
            //           bottomRight: Radius.circular(25))),
            //   title: Text("Delivery Page"),
            //   pinned: true,
            //   flexibleSpace: FlexibleSpaceBar(
            //     background:Center(
            //       child: Container(
            //         child: Text("Delivery Page22222 ${vm.deliveryList.length}"),
            //       ),
            //     ),
            //   ),
            //   actions: [
            //     IconButton(
            //       icon: Icon(Icons.add),
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
          ];
        },
        body: loading ? CircularProgressIndicator() : 
         Container(
          child: ListView.builder(
            itemCount: vm.deliveryList.length,
            itemBuilder: (BuildContext context, int index) {
              return DeliveryContent(index: index, delivery: vm.deliveryList[index]);
              // ListTile(
              //   leading: Icon(Icons.account_circle),
              //   trailing: Icon(Icons.keyboard_arrow_right),
              //   dense: true,
              //   tileColor: Colors.white,
              //   hoverColor: Colors.amber,
              //   title: Text("Delivery Page"),
              //   contentPadding: EdgeInsets.all(10),
              //   subtitle: Container(
              //     height: 100,
              //     decoration:
              //         BoxDecoration(border: Border.all(color: Colors.black)),
              //     child: Text("Delivery Page"),
              //   ),

              // );
            },
          ),
        ),
      ),
    );
  }
}