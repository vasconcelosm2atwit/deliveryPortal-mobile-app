import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/delivery_model.dart';
import '../models/driver_model.dart';
import '../models/item_model.dart';

class DriverService {
  DriverService();

  // get driver from firestore
  Future<List<Driver>> getDrivers() async {
    final QuerySnapshot<Map<String, dynamic>> drivers =
        await getCollections('drivers');
    final List<Driver> driversList = [];
    drivers.docs.forEach((doc) {
      print(doc);
      driversList.add(Driver.fromSnapshot(doc));
    });
    return driversList;
  }

  // get item by uid
  Future<DocumentSnapshot> getItemByUuid(String uuid) async {
    return await FirebaseFirestore.instance.collection('items').doc(uuid).get();
  }

  Future<Item> getItem(String? uuid) async {
    DocumentSnapshot snapshot = await getItemByUuid(uuid!);
    return Item.fromSnapshot(snapshot);
  }

  // update item using uid to scanned
  Future<void> updateItem(id, type) async {
    await FirebaseFirestore.instance.collection('items').doc(id).update({
      type: true,
    });
  }

  // set a status for all items
  Future<void> updateItemStatus(id, status) async {
    await FirebaseFirestore.instance.collection('items').doc(id).update({
      'status': status,
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollections(
      String collection) async {
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

  // get all deliveries from firestore with driver name Michelle Vasconcelos
  Future<QuerySnapshot<Map<String, dynamic>>> getDeliveriesByDriver(
      String driverEmail) async {
    return await FirebaseFirestore.instance
        .collection('deliveries')
        .where('assignedDriver', isEqualTo: driverEmail)
        .get();
  }

  Future<List<Delivery>> getAllDeliveriesByDriver(String driver) async {
    final deliveries =
        await getDeliveriesByDriver(driver);
    final List<Delivery> deliveryList = [];
    for (var doc in deliveries.docs) {
      deliveryList.add(Delivery.fromSnapshot(doc));
    }
    return deliveryList;
  }

  Future<List<Delivery>> getAllDeliveries() async {
    final QuerySnapshot<Map<String, dynamic>> deliveries =
        await getCollections('deliveries');
    final List<Delivery> deliveryList = [];
    for (var doc in deliveries.docs) {
      deliveryList.add(Delivery.fromSnapshot(doc));
    }
    return deliveryList;
  }

  // update delivery status
  Future<void> updateDelivery(String id, String status) async {
    await FirebaseFirestore.instance.collection('deliveries').doc(id).update({
      'status': status,
    });
  }
}
