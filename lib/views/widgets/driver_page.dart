import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  State<DriverPage> createState() => _driverPageState();
}

class _driverPageState extends State<DriverPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Driver Page"),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                child: Text("Driver Page"),
              ),
               Container(
                child: Text("Driver Page"),
              ),

            ],
          ),
        ),
      ],
    );
  }
}