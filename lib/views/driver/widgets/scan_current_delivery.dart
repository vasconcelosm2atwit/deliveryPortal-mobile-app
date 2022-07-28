// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../../../models/delivery_model.dart';
import '../../../models/item_model.dart';
import '../../../services/custom_text.dart';
import '../../../view_model/driver_view_model.dart';
import '../../deliveries/widgets/open_container.dart';

class ScanCurrentDelivery extends StatefulWidget {
  List<Item> items;
  Delivery delivery;
  Function(String) onScan;
  //DriverViewModel vm;
  ScanCurrentDelivery(
      {Key? key,
      required this.items,
      required this.onScan,
      required this.delivery})
      : super(key: key);

  @override
  State<ScanCurrentDelivery> createState() => _ScanCurrentDeliveryState();
}

class _ScanCurrentDeliveryState extends State<ScanCurrentDelivery> {
  @override
  void initState() {
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<DriverViewModel>(context,listen: false).getItems(widget.currentDelivery!);
    // });
    //print(widget.currentDelivery.name);
    //Provider.of<DriverViewModel>(context,listen: false).getItemsStatus(widget.delivery);
  }

  String _scanResult = "";
  void scanBarcode(Item item, context) async {
    // FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", false, ScanMode.DEFAULT)
    //      !.listen((barcode) {
    //       print(barcode);
    //      /// barcode to be used
    //      });
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    if (barcodeScanRes == item.id) {
      // print("CORRECT");
      setState(() {
        _scanResult = barcodeScanRes;
        widget.onScan(item.id!);
        item.status = "scanned";
      });
    }
    print(barcodeScanRes);
  }

  @override
  Widget build(BuildContext context) {
    //final dvm = Provider.of<DriverViewModel>(context);
    return Scaffold(
        backgroundColor: const Color(0xff080613),
        appBar: AppBar(
          title: Text("Scan Packages for ${widget.delivery.name}"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
            child: Center(
          child: Column(
            children: [
              // Text("Scan Delivery Page ${widget.items[0].name}"),
              // IconButton(
              //   icon: Icon(Icons.add),
              //   onPressed: (){
              //     //scanBarcode();
              //   },
              // ),
              Text(
                _scanResult,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              //ListView.builder(itemBuilder: itemBuilder, itemCount: widget.currentDelivery?.items?.length ?? 0,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        //print(widget.items[index].id);
                        if (widget.items[index].status != "scanned") {
                          scanBarcode(widget.items[index], context);
                        }
                      },
                      child: Card(
                          color: widget.items[index].status == "scanned"
                              ? Colors.green
                              : Colors.white,
                          elevation: 2.0,
                          child: ListTile(
                            //leading: Icon(Icons.unarchive),
                            // circle avatar with delivery number as leading
                            leading: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: CustomText(text: "${index + 1}")),
                            title: CustomText(text: widget.items[index].name),
                            subtitle: CustomText(
                              text: widget.items[index].id,
                              size: 10,
                            ),
                            trailing: Icon(
                                widget.items[index].status == "scanned"
                                    ? Icons.done
                                    : Icons.add),
                            //subtitle: Text("ITEM DESCRIPTION"),
                          )));
                },
              ),
              // Card(
              //   color: Colors.white,
              //   elevation: 2.0,
              //   child:
              // ListTile(
              //         leading: Icon(Icons.album),
              //         title: Text("ITEM NAME"),
              // )),

              // Card(
              //   color: Colors.white,
              //   elevation: 2.0,
              //   child: OpenContainer(
              //     transitionType: ContainerTransitionType.fadeThrough,
              //     closedColor: Theme.of(context).cardColor,
              //     closedElevation: 0.0,
              //     openElevation: 4.0,
              //     transitionDuration: Duration(milliseconds: 3500),
              //     openBuilder: (BuildContext context, VoidCallback _) => DriverPage(),
              //     closedBuilder: (BuildContext _, VoidCallback openContainer) {
              //       return ListTile(
              //         leading: Icon(Icons.album),
              //         title: Text("ITEM NAME"),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        )));
  }
}
