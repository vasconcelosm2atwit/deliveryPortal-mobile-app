// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors
import 'dart:math';

import 'package:deliveryportal_driver_app/views/deliveries/widgets/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../models/delivery_model.dart';
import '../../services/custom_text.dart';
import '../../view_model/driver_view_model.dart';
import '../driver/widgets/scan_current_delivery.dart';
import 'widgets/current_delivery_card.dart';
import 'widgets/deliveryList.dart';
import 'widgets/delivery_content.dart';
import 'widgets/head_panel.dart';

import 'widgets/open_container.dart';
import 'widgets/top_panel.dart';

class CurrentDeliveryPage extends StatefulWidget {
  const CurrentDeliveryPage({Key? key}) : super(key: key);

  @override
  State<CurrentDeliveryPage> createState() => _CurrentDeliveryPageState();
}

class _CurrentDeliveryPageState extends State<CurrentDeliveryPage> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<DriverViewModel>(context, listen: false).getTopItem();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //     Provider.of<DriverViewModel>(context, listen: false).getDeliveries();
    //     loading = false;
    // });

    // print(Provider.of<DriverViewModel>(context).deliveryList);
  }

  bool hovered = false;
  IconData start_icon = Icons.play_arrow;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xff080814),
      appBar: AppBar(
        title: const CustomText(
          text: "Current Deliveries",
          size: 20,
          color: Colors.white,
          weight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xff080613),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
          child: Column(children: [
        SizedBox(height: 30),
        Center(child: TopPanel()),
        SizedBox(height: 30),
        //DeliveryContentCard(),
        CustomText(
          text: "Delivery 1",
          size: 20,
          color: Colors.white,
          weight: FontWeight.bold,
        ),
        SizedBox(height: 30),
        Container(
            child: Column(children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.white, size: 40),
            title: CustomText(
              text: "John Doe",
              size: 18,
              color: Colors.white,
              weight: FontWeight.bold,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                CustomText(
                  text: "123 Street, City, State",
                  size: 14,
                  color: Colors.white54,
                  weight: FontWeight.bold,
                ),
                CustomText(
                  text: "4 items",
                  size: 12,
                  color: Colors.white54,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.white),
              onPressed: () {},
            ),
          ),
          SizedBox(height: 10),
          Container(
              //width: 400,
              //color: Colors.white,
              height: 130,
              // padding: EdgeInsets.all(0),
              child: timeLineWidgets(vm))
        ])),
        //SizedBox(height: 30),
        Row(
          children: [
            Expanded(child: Container()),
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.orange,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  start_icon = Icons.pause;
                });
              },
            ),
            Expanded(child: Container()),
            IconButton(
              icon: Icon(Icons.location_pin, color: Colors.blue, size: 30),
              onPressed: () {
                setState(() {
                  start_icon = Icons.pause;
                });
              },
            ),
            Expanded(child: Container()),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red, size: 30),
              onPressed: () {
                setState(() {
                  start_icon = Icons.pause;
                });
              },
            ),
            Expanded(child: Container()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CustomText(
                text: "Delivery Instructions",
                size: 18,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15),
          child: Row(
            children: [
              Container(
                child: CustomText(
                  text: "${vm.deliveryListCount}",
                  size: 15,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ])),
    );
  }

  void updateItemScanned(String itemID) async {
    await Provider.of<DriverViewModel>(context, listen: false)
        .updateItem(itemID, 'scanned');
  }

  Widget timeLineWidgets(vm) {
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        InkWell(
          splashColor: Colors.purple,
          onTap: () {
            setState(() {
              hovered = hovered ? false : true;
              start_icon = start_icon == Icons.play_arrow
                  ? Icons.check
                  : Icons.play_arrow;
            });

            print(vm.currentItemList);

            // dialog asking if user wants to start delivery
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Start Delivery"),
                  content:
                      Text("Are you sure you want to start this delivery?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: TimelineTile(
            alignment: TimelineAlign.start,
            axis: TimelineAxis.horizontal,
            isFirst: true,
            indicatorStyle: IndicatorStyle(
              iconStyle: IconStyle(
                iconData: start_icon,
                color: Color(0xFF27AA69),
              ),
              width: 50,
              height: 50,
              color: Colors.white, //Color(0xFF27AA69),
              padding: EdgeInsets.all(6),
            ),
            endChild: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 10, left: 20, bottom: 10),
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                label: Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 18,
                    color: hovered ? Colors.white : Colors.green,
                  ),
                ),
                backgroundColor: Colors.transparent,
                onPressed: () {},
              ),
            ),
            beforeLineStyle: LineStyle(
                color: start_icon == Icons.check ? Colors.green : Colors.grey,
                thickness: 4),
            afterLineStyle: LineStyle(
                color: start_icon == Icons.check ? Colors.green : Colors.grey,
                thickness: 4),
          ),
        ),
        InkWell(
          onTap: () => {
            //Provider.of<DriverViewModel>(context, listen: false);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScanCurrentDelivery(
                      items: vm.currentItemList, onScan: updateItemScanned)),
            )

            // OpenContainer(
            //   transitionType: ContainerTransitionType.fadeThrough,
            //   closedColor: Theme.of(context).cardColor,
            //   closedElevation: 0.0,
            //   openElevation: 4.0,
            //   tappable: true,
            //   transitionDuration: Duration(milliseconds: 1000),
            //   openBuilder: (BuildContext context, VoidCallback _) {
            //     // return ChangeNotifierProvider<DriverViewModel>.value(
            //     //     value: DriverViewModel(),
            //     //     child: ScanCurrentDelivery(currentDelivery: widget.delivery));
            //     // print("uuid ${vm.uuid}");
            //     return ScanCurrentDelivery(
            //         items: vm.currentItemList, onScan: updateItemScanned);
            //   },
            //   closedBuilder: (BuildContext _, VoidCallback openContainer) {
            //     return IconButton(
            //       icon: Icon(Icons.add),
            //       onPressed: openContainer,
            //     );
            //   },
            // ),
          },
          child: TimelineTile(
            alignment: TimelineAlign.start,
            axis: TimelineAxis.horizontal,
            isFirst: false,
            isLast: false,
            indicatorStyle: IndicatorStyle(
              iconStyle: IconStyle(
                iconData: Icons.qr_code,
                color: start_icon == Icons.check ? Colors.green : Colors.grey,
              ),
              width: 50,
              height: 50,
              color: Colors.white,
              padding: EdgeInsets.all(6),
            ),
            endChild: Container(
                //color: Colors.white,
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 20, left: 20, bottom: 10),
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    label: const Text(
                      "Scan",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    onPressed: () {},
                  ),
                )),
            beforeLineStyle: LineStyle(
                color: start_icon == Icons.check ? Colors.green : Colors.grey,
                thickness: 4),
            afterLineStyle: const LineStyle(
              color: Colors.grey,
            ),
          ),
        ),
        InkWell(
          onTap: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Finish Delivery"),
                  content:
                      Text("Are you sure you want to finish this delivery?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            )
          },
          child: TimelineTile(
            alignment: TimelineAlign.start,
            axis: TimelineAxis.horizontal,
            isFirst: false,
            isLast: true,
            indicatorStyle: IndicatorStyle(
              iconStyle: IconStyle(iconData: Icons.check, color: Colors.grey),
              width: 50,
              height: 50,
              color: Colors.white,
              padding: EdgeInsets.all(6),
            ),
            endChild: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 20, left: 20, bottom: 10),
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                label: const Text(
                  "Finish",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.transparent,
                onPressed: () {},
              ),
            ),
            // afterLineStyle: const LineStyle(
            //   color: Colors.green,
            // ),
            beforeLineStyle: const LineStyle(color: Colors.grey, thickness: 4),
          ),
        )
      ],
    );
  }
}
