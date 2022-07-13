// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:deliveryportal_driver_app/services/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../view_model/driver_view_model.dart';

class TopPanel extends StatefulWidget {
  const TopPanel({Key? key}) : super(key: key);

  @override
  State<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return Container(
        child: Row(
      children: [
        SizedBox(width: 50),
        CircularPercentIndicator(
          circularStrokeCap: CircularStrokeCap.round,
          radius: 60.0,
          lineWidth: 15.0,
          percent: vm.completedDeliveriesCount / vm.deliveryListCount,
          center: CustomText(
            text: "3/28",
            size: 18,
            color: Colors.white,
          ),
          progressColor: Colors.purple,
        ),
        SizedBox(width: 20),
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Today's Deliveries",
              size: 18,
              color: Colors.white,
            ),
            CustomText(
              text: "Total: ${vm.deliveryListCount}",
              size: 15,
              color: Colors.white,
            ),
            CustomText(
              text: "Completed: ${vm.completedDeliveriesCount}",
              size: 15,
              color: Colors.white,
            ),
            CustomText(
              text:
                  "Canceled: ${vm.deliveryListCount - vm.completedDeliveriesCount}",
              size: 15,
              color: Colors.white,
            ),
          ],
        ))
      ],
    ));
  }
}
