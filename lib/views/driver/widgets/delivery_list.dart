// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../services/custom_text.dart';
import '../../../view_model/driver_view_model.dart';
import 'delivery.dard.dart';
import 'list_content.dart';

class DeliveryList extends StatefulWidget {
  //List<Delivery> list = [];
  const DeliveryList({Key? key}) : super(key: key);

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return 
    Container(
    child: loading ? CircularProgressIndicator() : 
    Expanded(
      child:
    Container( 
      //height: 370,
      //color: Colors.black,
      margin: EdgeInsets.only(bottom: 20),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(25),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ],
      // ),
     // child:SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: vm.displayList.length,
            itemBuilder: (BuildContext context, int index) {
              //return CustomText(text: "test",color:Colors.white);
              return ListContent(index: index, delivery: vm.displayList[index]);
            },
          )
        //),
        //  SingleChildScrollView(
        //   child: ListView.builder(
        //     itemCount: vm.deliveryList.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return DeliveryCard();
        //       //return ListContent(index: index, delivery: vm.deliveryList[index]);
        //     },
        //   ),)
  )));
  }
}