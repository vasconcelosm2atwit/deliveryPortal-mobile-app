// ignore_for_file: file_names, unnecessary_import, unused_import,implementation_imports, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/delivery_model.dart';

class DeliveryContent extends StatefulWidget {
  int index = 0;
  Delivery delivery = Delivery();
  DeliveryContent({Key? key, required this.index, required this.delivery})
      : super(key: key);

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
        fragment: "%");
    print(url.toString());
    try {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    } catch (e) {
      // await launchRl(fallbackUrl, forceSafariVC: false, forceWebView: false);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
