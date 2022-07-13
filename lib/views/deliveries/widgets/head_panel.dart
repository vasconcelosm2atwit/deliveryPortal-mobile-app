// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:deliveryportal_driver_app/services/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/driver_view_model.dart';

class HeadPanel extends StatefulWidget {
  const HeadPanel({Key? key}) : super(key: key);

  @override
  State<HeadPanel> createState() => _HeadPanelState();
}

class _HeadPanelState extends State<HeadPanel> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return Container(
        child: Column(
      children: [
        Center(
          // circle avatar
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              child: Icon(Icons.person),
              radius: 50,
            ),
          ),
        ),
        SizedBox(height: 20),
        CustomText(
          text: "Michael Vasconcelos",
          size: 18,
          color: Colors.white,
        ),
        SizedBox(height: 30),
        Row(
          children: [
            // SizedBox(width: 10),
            Expanded(
              child: Chip(
                side: BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
                padding: EdgeInsets.all(0),
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.today),
                ),
                backgroundColor: Colors.white,
                label: CustomText(
                  text: "Total: ${vm.deliveryListCount}       ",
                  size: 12,
                  color: Colors.black,
                ),
              ),
            ),
            //SizedBox(width: 10),
            Expanded(
              child: Chip(
                side: BorderSide(
                  color: Colors.purple,
                  width: 2,
                ),
                padding: EdgeInsets.all(0),
                avatar: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.purple,
                  child: Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.white,
                label: CustomText(
                  text: "To do: ${vm.completedDeliveriesCount}   ",
                  size: 12,
                  color: Colors.black,
                ),
              ),
            ),
            //SizedBox(width: 10),
            Expanded(
              child: Container(
                // width: 100,
                child: Chip(
                  side: BorderSide(
                    color: Colors.brown,
                    width: 2,
                  ),
                  padding: EdgeInsets.all(0),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.brown,
                    child: Icon(Icons.done),
                  ),
                  backgroundColor: Colors.white,
                  label: CustomText(
                    text:
                        "Completed: ${vm.completedDeliveriesCount - vm.completedDeliveriesCount}",
                    size: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // Container(
            //   height: 120,
            //   width: 100,
            //   decoration: BoxDecoration(
            //     color: Colors.blueAccent.withOpacity(0.5),
            //     borderRadius: BorderRadius.all(
            //       Radius.circular(10),
            //     ),
            //   ),
            //   child: Column(children: [
            //     SizedBox(width: 10),
            //     Expanded(
            //         flex: 2,
            //         child: Center(
            //             child: Icon(
            //           Icons.check,
            //           size: 50,
            //           color: Colors.white,
            //         ))),
            //     Expanded(
            //         child: CustomText(
            //       text: "Total",
            //       size: 12,
            //       color: Colors.white,
            //       weight: FontWeight.bold,
            //     )),
            //     Expanded(
            //       child: CustomText(
            //         text: "${vm.deliveryListCount}",
            //         size: 18,
            //         color: Colors.white,
            //         weight: FontWeight.bold,
            //       ),
            //     )
            //   ]),
            // ),

            // SizedBox(width: 30),
            // Expanded(
            //   child: Container(
            //     height: 120,
            //     width: 100,
            //     decoration: BoxDecoration(
            //       color: Colors.blueAccent.withOpacity(0.5),
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(10),
            //       ),
            //     ),
            //     child: Column(children: [
            //       SizedBox(width: 10),
            //       Expanded(
            //           flex: 2,
            //           child: Center(
            //               child: Icon(
            //             Icons.check,
            //             size: 50,
            //             color: Colors.white,
            //           ))),
            //       Expanded(
            //           child: CustomText(
            //         text: "To do",
            //         size: 12,
            //         color: Colors.white,
            //         weight: FontWeight.bold,
            //       )),
            //       Expanded(
            //         child: CustomText(
            //           text: "${vm.completedDeliveriesCount}",
            //           size: 18,
            //           color: Colors.white,
            //           weight: FontWeight.bold,
            //         ),
            //       )
            //     ]),
            //   ),
            // ),
            // SizedBox(width: 30),
            // Expanded(
            //   child: Container(
            //     height: 120,
            //     width: 100,
            //     decoration: BoxDecoration(
            //       color: Colors.blueAccent.withOpacity(0.5),
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(10),
            //       ),
            //     ),
            //     child: Column(children: [
            //       Expanded(
            //           flex: 2,
            //           child: Center(
            //               child: Icon(
            //             Icons.check,
            //             size: 50,
            //             color: Colors.white,
            //           ))),
            //       Expanded(
            //           child: CustomText(
            //         text: "Completed",
            //         size: 12,
            //         color: Colors.white,
            //         weight: FontWeight.bold,
            //       )),
            //       Expanded(
            //         child: CustomText(
            //           text:
            //               "${vm.deliveryListCount - vm.completedDeliveriesCount}",
            //           size: 18,
            //           color: Colors.white,
            //           weight: FontWeight.bold,
            //         ),
            //       )
            //     ]),
            //   ),
            // ),
            SizedBox(width: 10),
          ],
        )
      ],
    ));
  }
}
