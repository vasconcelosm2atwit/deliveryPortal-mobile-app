import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/delivery_model.dart';
import '../models/driver_model.dart';

class DriverService {

  DriverService();
  
  // get driver from firestore
  Future<List<Driver>> getDrivers() async {
    final QuerySnapshot<Map<String, dynamic>> drivers = await getCollections('drivers');
    final List<Driver> driversList = [];
    drivers.docs.forEach((doc) {
      driversList.add(Driver.fromSnapshot(doc));
    });
    return driversList;
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getCollections(String collection) async {
    return await FirebaseFirestore.instance.collection(collection).get();
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

  Future<List<Delivery>> getAllDeliveries() async {
    final QuerySnapshot<Map<String, dynamic>> deliveries = await getCollections('deliveries');
    final List<Delivery> deliveryList = [];
    for (var doc in deliveries.docs) {
      deliveryList.add(Delivery.fromSnapshot(doc));
    }
    return deliveryList;
  }

}