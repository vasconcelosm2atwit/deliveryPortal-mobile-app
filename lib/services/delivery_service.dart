import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/driver_model.dart';


class DeliveryService{
    DeliveryService();
  
  // get driver from firestore
  Future<List<Driver>> getAllDeliveries() async {
    final QuerySnapshot<Map<String, dynamic>> deliveries = await getDeliveries();
    final List<Driver> deliveryList = [];
    deliveries.docs.forEach((doc) {
      deliveryList.add(Driver.fromSnapshot(doc));
    });
    print(deliveryList);
    return deliveryList;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDeliveries() async {
    return await FirebaseFirestore.instance.collection('deliveries').get();
  }

  // get driver from snapshot
  Future<Driver> getDriver(String? uuid) async {
    DocumentSnapshot snapshot = await getDriverByUuid(uuid!);
    return Driver.fromSnapshot(snapshot);
  }

  // get the snapshot from firestore with document id
  Future<DocumentSnapshot> getDriverByUuid(String uuid) async {
    return await FirebaseFirestore.instance
        .collection('drivers')
        .doc(uuid)
        .get();
  }
}