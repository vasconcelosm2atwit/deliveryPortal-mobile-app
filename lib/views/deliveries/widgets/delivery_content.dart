
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/delivery_model.dart';

class DeliveryContent extends StatefulWidget {
  int index=0;
  Delivery delivery = Delivery();
  DeliveryContent({Key? key, required this.index, required this.delivery}) : super(key: key);

  @override
  State<DeliveryContent> createState() => _DeliveryContentState();
}

class _DeliveryContentState extends State<DeliveryContent> {
  int start = 0;

  @override
  void initState() {
    super.initState();
    print(widget.delivery.name);
    
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
    print(url.toString());
    try {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication );
  } catch (e) {
   // await launchRl(fallbackUrl, forceSafariVC: false, forceWebView: false);
   print(e);
  }

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      //margin: EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(30),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(.5),
      //       spreadRadius: 2,
      //       blurRadius: 3,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ],
      // ),

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.white,
        elevation: 4.0,
        child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: Text("${widget.index + 1}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            title: Text("${widget.delivery.name}",),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.delivery.address}",style: TextStyle(fontSize: 12),),
                Text("${widget.delivery.phone}",style: TextStyle(fontSize: 12),),
                Row(
                  children: [
                  Icon(Icons.phone,color: Colors.blue,),
                  SizedBox(width: 10),
                  Icon(Icons.message,color: Colors.blue,),
                ],)
                
              ],
            ),
            trailing: CircleAvatar(
              radius: 35.0,
              backgroundColor: widget.index != 0 ? Colors.grey : Colors.green,
              child: Text("Start",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            )
            //  Text("${widget.delivery.address}"),
            ),
      ),
    );

    //   child: 
    //   // ListTile(
    //   //           leading: Icon(Icons.account_circle),
    //   //           //trailing: Icon(Icons.keyboard_arrow_right),
    //   //           title: Text("Delivery Page ${widget.index}"), 
    //   //           enabled: widget.index % 2 == 0 ? true : false,
    //   //           contentPadding: EdgeInsets.all(8),
    //   //           subtitle: Expanded(
    //   //             child:
    //   //           Container(
    //   //             height: 100,
    //   //             decoration:
    //   //                 BoxDecoration(border: Border.all(color: Colors.black)),
    //   //             child: Column(
    //   //               children: [
    //   //                 Text("Delivery Page ${start}"),
    //   //                 IconButton(
    //   //                 icon: Icon(Icons.add),
    //   //                 onPressed: (){
    //   //                   if(widget.index % 2 == 0){
    //   //                     setState(() {
    //   //                       start++;
    //   //                     });
    //   //                   }
    //   //                 },
    //   //                 ),
    //   //               ],
    //   //             ),
    //   //           )),

    //   //         ),

    //   // start here current
    //   Row(
    //     children: [
    //       CircleAvatar(
    //         radius: 25.0,
    //         backgroundColor: Colors.blueAccent,
    //         child: Text("${widget.index +1 }",
    //             style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.white)), 
    //       ),
    //       Expanded(
    //         child:
    //       //Column(
    //         //children: [
    //           // Row(
    //           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           //   children: [
    //           //     Text("Delivery Content"),
    //           //     // IconButton(
    //           //     //   icon: Icon(Icons.add),
    //           //     //   onPressed: () {},
    //           //     // ),
    //           //   ],
    //           // ),
              
    //           Container(
    //             // height: 100,
    //             // width: 300,
    //             margin: EdgeInsets.only(right:10,left:10),
    //             decoration: BoxDecoration(
    //               border: Border.all(color: Colors.white),
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   // Row(children: [
    //                   //   Text("Delivery Content"),
    //                   // ],),
    //                   Text("${widget.delivery.name}"),
    //                   Text("${widget.delivery.address}"),
    //                   Text("${widget.delivery.phone}"),
    //                   IconButton(
    //                   icon: Icon(Icons.start_rounded),
    //                   onPressed: (){
    //                     if(widget.index % 2 == 0){
    //                       setState(() {
    //                         start++;
    //                       });
    //                     }
    //                   },
    //                   )
    //                 ],
    //               )
    //             )
    //       ),
    //       InkWell(
    //         onTap: () {
    //           print(widget.delivery.address);
    //           launchWaze(widget.delivery.address);
    //         },
    //         child:
    //       CircleAvatar(
    //         radius: 35.0,
    //         backgroundColor: widget.index != 0 ? Colors.grey : Colors.green,
    //         child: Text("Start", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
    //       )),
       
    //       ]
        
    //   ), //end here current




    //   // Column(
    //   //   children: [
    //   //     Container(
    //   //       height: 200,
    //   //       color: Colors.white,
    //   //       child: Text("Delivery Content"),
    //   //     ),
    //   //   ],
    //   // ),

    // );
    
  }
}