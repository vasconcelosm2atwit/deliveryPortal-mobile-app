import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../services/custom_text.dart';
import '../../view_model/driver_view_model.dart';
import 'widgets/delivery_list.dart';
import 'widgets/head_panel.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  State<DriverPage> createState() => _driverPageState();
}

class _driverPageState extends State<DriverPage> {


  // List<Widget> panels = [
  //   DeliveryList(),
  //   CompletedList(),
  //   CanceledList()
  // ];

  String laodedLIst = "Todo Deliveries";

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.white],
                stops: [0, .6]
              )
            ),
          ),

        Padding(padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: CustomText(
                        text: "Hi, Michelle Vasconcelos",
                        size: 20,
                        color: Colors.black,
                        weight: FontWeight.bold,
                      )),
                  ],
                ),
                const SizedBox(height: 32,),
                Container(
                  height: 180,
                  child:HeadPanel() ,
                  
                  ),
                Expanded(
                  child:
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children:[
                    Row(children: [
                      CustomText(text: vm.currentListTitle, size: 18, weight: FontWeight.bold,)
                    ],),
                    DeliveryList(),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: 10,
                    //   itemBuilder: (context, index) {
                    //     return CustomText(text:"text");
                    //   },
                    ]
    
                  ),
                ),),
                
                // Container(
                //   child: CustomText(text: "Driver page3", size: 24),
                // ),
              ],
            )
          )
      ],
    );
  }
}