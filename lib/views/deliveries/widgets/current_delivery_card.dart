// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../services/custom_text.dart';
import '../../../view_model/driver_view_model.dart';

class DeliveryContentCard extends StatefulWidget {
  //List<Delivery> list = [];
  const DeliveryContentCard({Key? key}) : super(key: key);

  @override
  State<DeliveryContentCard> createState() => _DeliveryContentCardState();
}

class _DeliveryContentCardState extends State<DeliveryContentCard> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return Container(
        child: loading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    height: 200,
                    // color: Colors.black,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 4,
                            child: Container(color: Colors.blue),
                          ),

                        ),
                      ],
                    )),
              ));
  }
}
