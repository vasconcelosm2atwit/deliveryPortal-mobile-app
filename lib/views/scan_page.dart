import 'package:deliveryportal_driver_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import flutter animation
import 'package:flutter/animation.dart';

import 'deliveries/widgets/open_container.dart';
import 'widgets/driver_page.dart';

class ScanDeliveryPage extends StatefulWidget {
  const ScanDeliveryPage({Key? key}) : super(key: key);

  @override
  State<ScanDeliveryPage> createState() => _ScanDeliveryPageState();
}

class _ScanDeliveryPageState extends State<ScanDeliveryPage> {

  String _scanResult = "";
  void scanBarcode() async {
    // FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", false, ScanMode.DEFAULT)
    //      !.listen((barcode) { 
    //       print(barcode);
    //      /// barcode to be used
    //      });
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT);
    print(barcodeScanRes);
    setState(() {
      _scanResult = barcodeScanRes;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Delivery"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DriverPage()),
                )
        ),
      ),

      body: Container(
      child: Center(
        child: Column(
          children: [
            Text("Scan Delivery Page"),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                scanBarcode();
              },
            ),
            Text(_scanResult, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Card(
              color: Colors.white,
              elevation: 2.0,
              child: OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: Theme.of(context).cardColor,
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: Duration(milliseconds: 1500),
                openBuilder: (BuildContext context, VoidCallback _) => DriverPage(),
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return ListTile(
                    leading: Icon(Icons.album),
                    title: Text("ITEM NAME"),
                  );
                },
              ),
            )
          ],
        ),
      )
    )
    );
    
    
    
  }
}