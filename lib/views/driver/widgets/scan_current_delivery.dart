// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../models/delivery_model.dart';
import '../../../models/item_model.dart';
import '../../../services/custom_text.dart';
import '../../../view_model/driver_view_model.dart';
import '../../deliveries/widgets/open_container.dart';

class ScanCurrentDelivery extends StatefulWidget {
  List<Item> items;
  Function(String) onScan;
  //DriverViewModel vm;
  ScanCurrentDelivery({Key? key, required this.items, required this.onScan}) : super(key: key);

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
  }

  String _scanResult = "";
  void scanBarcode(Item item) async {
    // FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", false, ScanMode.DEFAULT)
    //      !.listen((barcode) { 
    //       print(barcode);
    //      /// barcode to be used
    //      });
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT);
    if(barcodeScanRes == item.id){
      print("CORRECT");
    }
    print(barcodeScanRes);
    setState(() {
      _scanResult = barcodeScanRes;
      item.confirmed = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    //final driverViewModel = Provider.of<DriverViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Delivery"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Container(
      child: Center(
        child: Column(
          children: [
            Text("Scan Delivery Page ${widget.items[0].name}"),
            // IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: (){
            //     //scanBarcode();
            //   },
            // ),
            Text(_scanResult, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            //ListView.builder(itemBuilder: itemBuilder, itemCount: widget.currentDelivery?.items?.length ?? 0,),
            ListView.builder(
              shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell( 
                onTap: (){
                  //print(widget.items[index].id);
                  scanBarcode(widget.items[index]);
                  
                },
                child: Card(
                color: widget.items[index].confirmed! ? Colors.green : Colors.white,
                elevation: 2.0,
                child:
                ListTile(
                    leading: Icon(Icons.album),
                    title: CustomText(text: widget.items[index].name),
                    //subtitle: Text("ITEM DESCRIPTION"),
                  )
                
                ));
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
      )
    )
    );
    
  }
}