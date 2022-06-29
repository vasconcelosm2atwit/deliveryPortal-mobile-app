import 'package:deliveryportal_driver_app/services/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/driver_view_model.dart';

class HeadPanel extends StatefulWidget {
  const HeadPanel({Key? key}) : super(key: key);

  @override
  State<HeadPanel> createState() => _HeadPanelState();
}

class _HeadPanelState extends State<HeadPanel> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return 
    Stack(
      children: [
        Container(
          height: 150,
          decoration: const BoxDecoration(
          // color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Card(
            color: Colors.blue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20),
              ),
            ),
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom:10.0, left:30.0, right:10.0, top:20.0),
              child: ListTile(
                leading: const Icon(Icons.arrow_circle_right_rounded , color: Colors.white,),
                title: const CustomText(text:"Today's Deliveries",size:18,color: Colors.white,),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(text:"Total Deliveries: ${vm.deliveryListCount}",size:15,color: Colors.white54,),
                    CustomText(text:"Total Completed: ${vm.completedDeliveriesCount}",size:15, color: Colors.white54,),
                    CustomText(text:"Remaining Completed: ${vm.deliveryListCount - vm.completedDeliveriesCount}",size:15, color: Colors.white54,),
                  ],
                )
              ),
            ),
        )),
        Positioned
        (
          top: 120,
          left: 100, 
          child: Card(
            elevation: 5.0,
          child: Row(
            children: [
              IconButton(onPressed: (){
                vm.setDisplayList("todo");
              }, icon: const Icon(Icons.assignment)),
              const SizedBox(width: 10,),
              IconButton(onPressed: (){
                vm.setDisplayList("completed");
              }, icon: const Icon(Icons.done)),
              const SizedBox(width: 10,),
              IconButton(onPressed: (){
                vm.setDisplayList("cancelled");
              }, icon: const Icon(Icons.cancel)),
            ],
          )
        
        ))
      ],
    );
    
    
  }
}