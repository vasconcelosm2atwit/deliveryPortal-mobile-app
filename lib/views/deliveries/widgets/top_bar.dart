// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../services/custom_text.dart';
import '../../../view_model/driver_view_model.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return SliverAppBar(
              backgroundColor: Colors.white,
              //shadowColor: Colors.amber,
              expandedHeight: 400.0,
              elevation: 8.0,
              floating: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              title: Text("Deliveries",style: TextStyle(color: Colors.black),),
              centerTitle: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background:Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 50,left:30),
                    child: 
                    
                    Center(
                      child: Container(
                        width: 450,
                        height: 100,
                        child: ListTile(
                         // tileColor: Colors.white,
                          leading: Icon(Icons.person_outline_rounded,color: Colors.black,size: 50,),
                          title: CustomText(
                            text: "Michael Vasconcelos",
                            size: 20,
                            color: Colors.black,
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                
                            Row(
                              children: [
                                CustomText(
                                  text: "Total Deliveries: ${vm.deliveryList.length}",
                                  size: 15,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(
                                  text: "Completed Deliveries: 0",
                                  size: 15,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                          
                        ),
                    
                        ),
                      ),
                    )
                    
                    
                    // Column(children: [
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       CircleAvatar(
                    //         radius: 30,
                    //         child:Icon(Icons.person)
                    //       ),
                    //       SizedBox(width:10),
                    //       CustomText(
                    //         text: "${vm.driver.name}",
                    //         size: 20,
                    //         weight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //     ],
                    //   ),
                    //   SizedBox(height:10),
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       CustomText(
                    //         text: "Total Deliveries: ",
                    //         size: 20,
                    //         weight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       SizedBox(width:10),
                    //       CustomText(
                    //         text: "${vm.deliveryList.length}",
                    //         size: 15,
                    //         weight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //     ],
                    //   ),
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       CustomText(
                    //         text: "Deliveries Completed: ",
                    //         size: 20,
                    //         weight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       SizedBox(width:10),
                    //       CustomText(
                    //         text: "${0}",
                    //         size: 15,
                    //         weight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //     ],
                    //   ),
                    
                    
                    
                    // // Text("Deliveries Completed: ${vm.deliveryList.length}/${vm.deliveryList.length}", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold, color: Colors.white))
                    // ],
                    // ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            );
    
  }
}