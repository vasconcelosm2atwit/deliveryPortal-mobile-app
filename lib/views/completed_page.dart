// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CompletedDeliveryPage extends StatefulWidget {
  const CompletedDeliveryPage({Key? key}) : super(key: key);

  @override
  State<CompletedDeliveryPage> createState() => _CompletedDeliveryPageState();
}

class _CompletedDeliveryPageState extends State<CompletedDeliveryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Completed Delivery Page"),
    );
  }
}