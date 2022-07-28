// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../models/delivery_model.dart';
import '../../../services/custom_text.dart';
import '../../../view_model/driver_view_model.dart';

class DeliveryList extends StatefulWidget {
  List<Delivery> delivery_list = [];
  DeliveryList({Key? key, required this.delivery_list }) : super(key: key);

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    //final vm = Provider.of<DriverViewModel>(context);
    return Container(
        child: loading
            ? CircularProgressIndicator()
            : Expanded(
                child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.delivery_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        //return CustomText(text: "test",color:Colors.white);
                        return ExpansionTile(
                          trailing: Icon(Icons.arrow_circle_right,
                              color: Colors.white),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person),
                            radius: 20,
                          ),
                          title: CustomText(
                            //text: "${vm.displayList[index].name}",
                            text: "${widget.delivery_list[index].name}",
                            size: 18,
                            color: Colors.white,
                          ),
                          // subtitle: CustomText(
                          //   text: "Total Deliveries: ${vm.deliveryListCount}",
                          //   size: 15,
                          //   color: Colors.white,
                          // ),
                          children: [
                            CustomText(
                              text: "Total Deliveries : ${widget.delivery_list.length}",
                              size: 15,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ],
                            )
                          ],
                        );
                        //DeliveryContent(index: index, delivery: vm.displayList[index]);
                      },
                    ))));
  }
}
