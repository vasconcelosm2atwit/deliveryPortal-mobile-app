
// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/delivery_model.dart';
import '../../../services/custom_text.dart';
import '../../../view_model/driver_view_model.dart';
import '../../deliveries/widgets/open_container.dart';
import '../../scan_page.dart';
import 'scan_current_delivery.dart';

class ListContent extends StatefulWidget {
  int index=0;
  Delivery delivery = Delivery();
  ListContent({Key? key, required this.index, required this.delivery}) : super(key: key);

  @override
  State<ListContent> createState() => _ListContentState();
}

class _ListContentState extends State<ListContent> {
  int start = 0;

  @override
  void initState() {
    super.initState();
    //print(widget.delivery.name);
    Provider.of<DriverViewModel>(context,listen: false).getItems(widget.delivery);
    
  }


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
      fragment: "%"
    );
    //print(url.toString());
    try {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication );
  } catch (e) {
   // await launchRl(fallbackUrl, forceSafariVC: false, forceWebView: false);
   print(e);
  }

  }

  void updateItemScanned(String itemID) async {
    await Provider.of<DriverViewModel>(context,listen: false).updateItem(itemID, 'scanned');
  }


  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom:15, top: 15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        elevation: 4.0,
        child: ListTile(
            leading: Icon(Icons.delivery_dining , color: Colors.blue,size: 50),
            
            // CircleAvatar(
            //   radius: 35.0,
            //   backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            //   child: Text("${widget.index + 1}",
            //       style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white)),
            // ),
            title: Row(children: [
              CustomText(text:"${widget.delivery.name}"),
              // SizedBox(width: 10,),
              // Chip(
              //   label: CustomText(text:"Started", size: 10, color: Colors.white),
              //   backgroundColor: Colors.green,
              //   //avatar: CircleAvatar(child: Text("Delivery"[0].toUpperCase())),
              // ),
              
              ]),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.delivery.address}",style: TextStyle(fontSize: 12),),
                //Text("${widget.delivery.phone}",style: TextStyle(fontSize: 12),),
                SizedBox(height: 5),
                Row(
                  children: [
                  IconButton(
                    icon: Icon(Icons.phone,color: Colors.blue, size: 25),
                    onPressed: (){
                      Provider.of<DriverViewModel>(context, listen: false).deliveryList[0].status = "completed";
                    },
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.message,color: Colors.blue,size: 25),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.map ,color: Colors.blue,size: 25),
                    onPressed: (){
                      launchWaze(widget.delivery.address);
                    },
                  ),
                ],)
                
              ],
            ),
            trailing: widget.delivery.status == "todo" ?
            OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: Theme.of(context).cardColor,
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: Duration(milliseconds: 1000),
                openBuilder: (BuildContext context, VoidCallback _) {
                  // return ChangeNotifierProvider<DriverViewModel>.value(
                  //     value: DriverViewModel(),
                  //     child: ScanCurrentDelivery(currentDelivery: widget.delivery));
                  print("uuid ${vm.uuid}");
                  return ScanCurrentDelivery(items: vm.currentItemList, onScan: updateItemScanned);
                },
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return  CircleAvatar(
              radius: 35.0,
              backgroundColor: widget.index != 0 ? Colors.grey : Colors.green,
              child: Text(widget.delivery.status == "completed" ? "Done" : "Scan",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            );
                },
              )
              : Icon(Icons.done),
            
            // InkWell(
            //   onTap: (){
                
            //   },
            //   child:
            // CircleAvatar(
            //   radius: 35.0,
            //   backgroundColor: widget.index != 0 ? Colors.grey : Colors.green,
            //   child: Text("start",
            //       style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white)),
            // ))
            //  Text("${widget.delivery.address}"),
            ),
      ),
    );
    
  }
}