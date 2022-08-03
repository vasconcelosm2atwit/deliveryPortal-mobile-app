// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors
import 'dart:math';

import 'package:deliveryportal_driver_app/views/deliveries/widgets/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/delivery_model.dart';
import '../../models/item_model.dart';
import '../../services/custom_text.dart';
import '../../view_model/driver_view_model.dart';
import '../driver/widgets/scan_current_delivery.dart';
import 'widgets/current_delivery_card.dart';
import 'widgets/deliveryList.dart';
import 'widgets/delivery_content.dart';
import 'widgets/head_panel.dart';

import 'widgets/initial_scan_page.dart';
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
    Provider.of<DriverViewModel>(context, listen: false).getAllItems();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //     Provider.of<DriverViewModel>(context, listen: false).getDeliveries();
    //     loading = false;
    // });

    //allItems = Provider.of<DriverViewModel>(context).allItems;
    // readyItems = allItems.where((item) => item.status != 'not_ready').toList();

    // print(Provider.of<DriverViewModel>(context).deliveryList);
  }

  bool hovered = false;

  void launchWaze(String? address) async {
    address = address?.replaceAll(",", "").trim();
    var url = Uri(
        scheme: 'https',
        host: 'waze.com',
        path: 'ul',
        queryParameters: {
          'q': '${address}',
          'navigate': 'yes',
          'zoom': '17',
        },
        fragment: "%");
    //print(url.toString());
    try {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    } catch (e) {
      // await launchRl(fallbackUrl, forceSafariVC: false, forceWebView: false);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    final currentDelivery =
        Provider.of<DriverViewModel>(context).currentDelivery;
    IconData start_icon =
        currentDelivery.status != 'todo' ? Icons.check : Icons.play_arrow;

    IconData scan_icon =
        currentDelivery.status == 'scanned' ? Icons.check : Icons.qr_code;

    IconData end_icon = currentDelivery.status == 'completed'
        ? Icons.check
        : Icons.check_box_outlined;
    final allItems = vm.allItems;
    final readyItems =
        allItems.where((item) => item.status != 'not_ready').toList();

    final loadingItems = vm.loadingItems;

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
      // body: allItems.length != readyItems.length
      //     ? initalScan(readyItems.length, allItems.length, allItems)
      //     : currentDeliveryWidget(
      //         vm, currentDelivery, start_icon, scan_icon, end_icon)
      body: Container(
          child: Column(children: [
        SizedBox(height: 30),
        if (allItems.length == readyItems.length)
          Center(child: TopPanel())
        else
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(
                child: CustomText(
              text: "Scan All Items To Start Delivery...",
              size: 20,
              color: Colors.white,
              weight: FontWeight.bold,
            )),
          ),
        SizedBox(height: 30),
        //DeliveryContentCard(),

        if (allItems.length != readyItems.length)
          initalScan(readyItems.length, allItems.length, allItems, loadingItems)
        else
          currentDeliveryWidget(
              vm, currentDelivery, start_icon, scan_icon, end_icon),
        // CustomText(
        //   text: "Delivery ${vm.completedDeliveriesCount + 1}",
        //   size: 20,
        //   color: Colors.white,
        //   weight: FontWeight.bold,
        // ),
        // SizedBox(height: 30),
        // Container(
        //     child: Column(children: [
        //   ListTile(
        //     leading: Icon(Icons.person, color: Colors.white, size: 40),
        //     title: CustomText(
        //       text: "${currentDelivery.name}",
        //       size: 18,
        //       color: Colors.white,
        //       weight: FontWeight.bold,
        //     ),
        //     subtitle: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       // ignore: prefer_const_literals_to_create_immutables
        //       children: [
        //         CustomText(
        //           text: "${currentDelivery.address}",
        //           size: 14,
        //           color: Colors.white54,
        //           weight: FontWeight.bold,
        //         ),
        //         CustomText(
        //           text: "${vm.currentItemListLength} items",
        //           size: 12,
        //           color: Colors.white54,
        //           weight: FontWeight.bold,
        //         ),
        //       ],
        //     ),
        //     trailing: IconButton(
        //       icon: Icon(Icons.call, color: Colors.white),
        //       onPressed: () {},
        //     ),
        //   ),
        //   SizedBox(height: 30),
        //   Container(
        //       //width: 400,
        //       //color: Colors.white,
        //       height: 130,
        //       // padding: EdgeInsets.all(0),
        //       child: timeLineWidgets(
        //           vm, currentDelivery, start_icon, scan_icon, end_icon)),
        // ])),
        // //SizedBox(height: 30),
        // Row(
        //   children: [
        //     Expanded(child: Container()),
        //     IconButton(
        //       icon: Icon(
        //         Icons.notifications,
        //         color: Colors.orange,
        //         size: 30,
        //       ),
        //       onPressed: () {
        //         Provider.of<DriverViewModel>(context, listen: false)
        //             .getTopItem();
        //         // setState(() {
        //         //   start_icon = Icons.pause;
        //         // });
        //       },
        //     ),
        //     Expanded(child: Container()),
        //     IconButton(
        //       icon: Icon(Icons.location_pin, color: Colors.blue, size: 30),
        //       onPressed: () {
        //         setState(() {
        //           start_icon = Icons.pause;
        //           launchWaze(currentDelivery.address);
        //         });
        //       },
        //     ),
        //     Expanded(child: Container()),
        //     IconButton(
        //       icon: Icon(Icons.cancel, color: Colors.red, size: 30),
        //       onPressed: () {
        //         showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return AlertDialog(
        //               title: Text("Cancel Delivery"),
        //               content: Text(
        //                   "Are you sure you want to cancel this delivery?"),
        //               actions: <Widget>[
        //                 FlatButton(
        //                   child: Text("Yes"),
        //                   onPressed: () {
        //                     vm.updateDelivery(currentDelivery.id, "canceled");
        //                     Navigator.of(context).pop();
        //                     vm.getDeliveries();
        //                     vm.getTopItem();
        //                   },
        //                 ),
        //                 FlatButton(
        //                   child: Text("No"),
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                   },
        //                 ),
        //               ],
        //             );
        //           },
        //         );
        //       },
        //     ),
        //     Expanded(child: Container()),
        //   ],
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child: Row(
        //     // ignore: prefer_const_literals_to_create_immutables
        //     children: [
        //       CustomText(
        //         text: "Delivery Instructions",
        //         size: 18,
        //         color: Colors.white,
        //         weight: FontWeight.bold,
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(width: 10),
        // Padding(
        //   padding: const EdgeInsets.only(right: 15.0, left: 15),
        //   child: Row(
        //     children: [
        //       Container(
        //         child: CustomText(
        //           text: "Drop by the front door please!",
        //           size: 15,
        //           color: Colors.white54,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ])),
    );
  }

  Widget currentDeliveryWidget(
      vm, currentDelivery, start_icon, scan_icon, end_icon) {
    return Column(
      children: [
        CustomText(
          text: "Delivery ${vm.completedDeliveriesCount + 1}",
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
              text: "${currentDelivery.name}",
              size: 18,
              color: Colors.white,
              weight: FontWeight.bold,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                CustomText(
                  text: "${currentDelivery.address}",
                  size: 14,
                  color: Colors.white54,
                  weight: FontWeight.bold,
                ),
                CustomText(
                  text: "${vm.currentItemListLength} items",
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
          SizedBox(height: 30),
          Container(
              //width: 400,
              //color: Colors.white,
              height: 130,
              // padding: EdgeInsets.all(0),
              child: timeLineWidgets(vm, currentDelivery, start_icon, scan_icon,
                  end_icon, vm.loadingItems)),
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
                Provider.of<DriverViewModel>(context, listen: false)
                    .getTopItem();
                // setState(() {
                //   start_icon = Icons.pause;
                // });
              },
            ),
            Expanded(child: Container()),
            IconButton(
              icon: Icon(Icons.location_pin, color: Colors.blue, size: 30),
              onPressed: () {
                setState(() {
                  start_icon = Icons.pause;
                  launchWaze(currentDelivery.address);
                });
              },
            ),
            Expanded(child: Container()),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Cancel Delivery"),
                      content: Text(
                          "Are you sure you want to cancel this delivery?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Yes"),
                          onPressed: () {
                            vm.updateDelivery(currentDelivery.id, "canceled");
                            Navigator.of(context).pop();
                            vm.getDeliveries();
                            vm.getTopItem();
                          },
                        ),
                        TextButton(
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
                  text: "Drop by the front door please!",
                  size: 15,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void updateItemScanned(String itemID) async {
    await Provider.of<DriverViewModel>(context, listen: false)
        .updateItemStatus(itemID, 'scanned');
  }

  Widget timeLineWidgets(DriverViewModel vm, currentDelivery, start_icon,
      scan_icon, end_icon, loadingItems) {
    return loadingItems
        ? Center(child: CircularProgressIndicator())
        : ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              InkWell(
                splashColor: Colors.purple,
                onTap: () async {
                  // print(vm.currentItemList);
                  print("starting pos --------------------------------------");
                  //vm.checkLocationPermission();
                  await vm.determineCurrentPosition();
                  print("current pos --------------------------------------");
                  //print(vm.currentListTitle);
                  print("open route START");
                  //await vm.openroutetest();
                  print("open rout END");
                  debugPrint(
                      "DEBUG PRINT --------------------------------------");
                  //vm.sendMessage();
                  print("send message END");
                  vm.checkDistanceBetween();
                  //print(t);
                  print("send test END");

                  // dialog asking if user wants to start delivery
                  if (currentDelivery.status == "todo") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Start Delivery"),
                          content: Text(
                              "Are you sure you want to start this delivery?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Yes"),
                              onPressed: () {
                                vm.updateDelivery(
                                    currentDelivery.id, "started");
                                Navigator.of(context).pop();
                                setState(() {
                                  //hovered = hovered ? false : true;
                                  start_icon = Icons.check;
                                });
                                launchWaze(currentDelivery.address);
                              },
                            ),
                            TextButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  axis: TimelineAxis.horizontal,
                  isFirst: true,
                  indicatorStyle: IndicatorStyle(
                    iconStyle: IconStyle(
                      iconData: start_icon,
                      // iconData: currentDelivery.status == 'started'
                      //     ? Icons.check
                      //     : Icons.play_arrow,
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
                      color: start_icon == Icons.check
                          ? Colors.green
                          : Colors.grey,
                      thickness: 4),
                  afterLineStyle: LineStyle(
                      color: start_icon == Icons.check
                          ? Colors.green
                          : Colors.grey,
                      thickness: 4),
                ),
              ),
              InkWell(
                onTap: () {
                  //Provider.of<DriverViewModel>(context, listen: false);
                  if (vm.completedDeliveriesCount == 1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Warning Check Your Location"),
                          content: Text(
                              "It seems that you are not near this delivery's address, are you sure you want to continue?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Yes"),
                              onPressed: () {
                                if (currentDelivery.status == "started") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ScanCurrentDelivery(
                                                items: vm.currentItemList,
                                                onScan: updateItemScanned,
                                                delivery: currentDelivery)),
                                  );
                                  var count = 0;
                                  for (var item in vm.currentItemList) {
                                    if (item.status == "scanned") {
                                      count++;
                                    }
                                  }
                                  if (count == vm.currentItemList.length) {
                                    vm.updateDelivery(
                                        currentDelivery.id, "scanned");
                                  }
                                  setState(() {
                                    //hovered = hovered ? false : true;
                                    scan_icon = Icons.check;
                                  });
                                }
                              },
                            ),
                            TextButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    if (currentDelivery.status == "started") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScanCurrentDelivery(
                                items: vm.currentItemList,
                                onScan: updateItemScanned,
                                delivery: currentDelivery)),
                      );
                      var count = 0;
                      for (var item in vm.currentItemList) {
                        if (item.status == "scanned") {
                          count++;
                        }
                      }
                      if (count == vm.currentItemList.length) {
                        vm.updateDelivery(currentDelivery.id, "scanned");
                      }
                    }
                    //vm.updateDelivery(currentDelivery.id, "scanned");
                  }
                },
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  axis: TimelineAxis.horizontal,
                  isFirst: false,
                  isLast: false,
                  indicatorStyle: IndicatorStyle(
                    iconStyle: IconStyle(
                      iconData: scan_icon,
                      color: start_icon == Icons.check
                          ? Colors.green
                          : Colors.grey,
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
                          label: Text(
                            "Scan",
                            style: TextStyle(
                              fontSize: 18,
                              color: start_icon == Icons.check
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          onPressed: () {},
                        ),
                      )),
                  beforeLineStyle: LineStyle(
                      color: start_icon == Icons.check
                          ? Colors.green
                          : Colors.grey,
                      thickness: 4),
                  afterLineStyle: LineStyle(
                      color:
                          scan_icon == Icons.check ? Colors.green : Colors.grey,
                      thickness: 4),
                ),
              ),
              InkWell(
                onTap: () => {
                  if (currentDelivery.status == "scanned")
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Finish Delivery"),
                            content: Text(
                                "Are you sure you want to finish this delivery?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  vm.updateDelivery(
                                      currentDelivery.id, "completed");
                                  vm.getDeliveries();
                                  vm.getTopItem();
                                  Navigator.of(context).pop();
                                  setState(() {
                                    //hovered = hovered ? false : true;
                                    end_icon = Icons.check;
                                  });
                                },
                              ),
                              TextButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      )
                    }
                },
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  axis: TimelineAxis.horizontal,
                  isFirst: false,
                  isLast: true,
                  indicatorStyle: IndicatorStyle(
                    iconStyle: IconStyle(
                      iconData: end_icon,
                      color:
                          scan_icon == Icons.check ? Colors.green : Colors.grey,
                    ),
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
                  //beforeLineStyle: const LineStyle(color: Colors.grey, thickness: 4),
                  beforeLineStyle: LineStyle(
                      color:
                          scan_icon == Icons.check ? Colors.green : Colors.grey,
                      thickness: 4),
                  // afterLineStyle: LineStyle(
                  //     color: end_icon == Icons.check ? Colors.green : Colors.grey,
                  //     thickness: 4),
                ),
              )
            ],
          );
  }

  void initialScanUpdate(String itemID) async {
    await Provider.of<DriverViewModel>(context, listen: false)
        .updateItemStatus(itemID, 'ready');
  }

  Widget initalScan(readyItems, totalItems, List<Item> allItems, loadingItems) {
    return loadingItems
        ? Center(child: CircularProgressIndicator())
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InitialScanPage(
                        items: allItems, onScan: initialScanUpdate)),
              );
            },
            child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircularPercentIndicator(
                    circularStrokeCap: CircularStrokeCap.round,
                    radius: 20.0,
                    lineWidth: 10.0,
                    percent: readyItems / totalItems,
                    center: CustomText(
                      text: "$readyItems/$totalItems",
                      size: 5,
                      color: Colors.white,
                    ),
                    progressColor: Colors.green,
                  ),
                  title: CustomText(
                      text: "${readyItems} / ${totalItems} Items Scanned"),
                  // subtitle: CustomText(
                  //   text: "${readyItems} / ${totalItems} items remaining",
                  //   size: 12,
                  // ),
                  trailing: Icon(Icons.add),
                )));
  }
}
