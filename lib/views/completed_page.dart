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