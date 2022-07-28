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

class InitialScanPage extends StatefulWidget {
  List<Item> items;
  Function(String) onScan;
  //DriverViewModel vm;
  InitialScanPage({Key? key, required this.items, required this.onScan})
      : super(key: key);

  @override
  State<InitialScanPage> createState() => _InitialScanPageState();
}

class _InitialScanPageState extends State<InitialScanPage> {
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
      print("CORRECT");
      setState(() {
        _scanResult = barcodeScanRes;
        widget.onScan(item.id!);
        item.status = "ready";
      });
    }

    print("CORRECT");
      setState(() {
        _scanResult = barcodeScanRes;
        widget.onScan(item.id!);
        item.status = "ready";
      });
    print(barcodeScanRes);
  }

  @override
  Widget build(BuildContext context) {
    //final dvm = Provider.of<DriverViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xff080613),
      appBar: AppBar(
        title: Text("Scan Packages"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                //print(widget.items[index].id);
                if (widget.items[index].status != "ready") {
                  scanBarcode(widget.items[index], context);
                }
              },
              child: Card(
                  color: widget.items[index].status == "ready"
                      ? Colors.green
                      : Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    //leading: Icon(Icons.unarchive),
                    // circle avatar with delivery number as leading
                    leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: CustomText(text: "${index + 1}")),
                    title: CustomText(text: widget.items[index].CustomerName),
                    subtitle: CustomText(
                      text: widget.items[index].name,
                      size: 10,
                    ),
                    trailing: Icon(widget.items[index].status == "ready"
                        ? Icons.done
                        : Icons.add),
                    //subtitle: Text("ITEM DESCRIPTION"),
                  )));
        },
      ),
    );
  }
}
