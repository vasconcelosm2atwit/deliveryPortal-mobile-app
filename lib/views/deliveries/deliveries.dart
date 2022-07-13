import 'package:deliveryportal_driver_app/views/deliveries/widgets/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../models/delivery_model.dart';
import '../../services/custom_text.dart';
import '../../view_model/driver_view_model.dart';
import 'widgets/deliveryList.dart';
import 'widgets/delivery_content.dart';
import 'widgets/head_panel.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xff080814),
      appBar: AppBar(
        title: const CustomText(
          text: "Deliveries",
          size: 30,
          color: Colors.white,
          weight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xff080613),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
          child: Column(children: [
        HeadPanel(),
        SizedBox(height: 30),

        /// badget icon with text

        Expanded(
          child: Container(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Row(
                children: [
                  CustomText(
                    text: "Today Deliveries",
                    size: 18,
                    color: Colors.white,
                    weight: FontWeight.bold,
                  )
                ],
              ),
              DeliveryList(),
            ]),
          ),
        ),

        /// text with a circle
        ///

        // expansion tile
        // ExpansionTile(
        //   trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white),
        //   leading: Icon(
        //     Icons.person,
        //     color: Colors.white,
        //   ),
        //   title: CustomText(
        //     text: "Today's Deliveries",
        //     size: 18,
        //     color: Colors.white,
        //   ),
        //   subtitle: CustomText(
        //     text: "Total Deliveries: ${vm.deliveryListCount}",
        //     size: 15,
        //     color: Colors.white,
        //   ),
        //   children: [
        //     CustomText(
        //       text: "Total Deliveries: ${vm.deliveryListCount}",
        //       size: 15,
        //       color: Colors.white,
        //     ),
        //   ],
        // ),
        // ExpansionTile(
        //   title: const CustomText(
        //     text: "Today's Deliveries",
        //     size: 18,
        //     color: Colors.white,
        //   ),
        //   children: [
        //     CustomText(
        //       text: "Total Deliveries: ${vm.deliveryListCount}",
        //       size: 15,
        //       color: Colors.white,
        //     ),
        //   ],
        // ),
        // ExpansionTile(
        //   title: const CustomText(
        //     text: "Today's Deliveries",
        //     size: 18,
        //     color: Colors.white,
        //   ),
        //   children: [
        //     CustomText(
        //       text: "Total Deliveries: ${vm.deliveryListCount}",
        //       size: 15,
        //       color: Colors.white,
        //     ),
        //   ],
        // ),
      ])),
    );
  }
}
