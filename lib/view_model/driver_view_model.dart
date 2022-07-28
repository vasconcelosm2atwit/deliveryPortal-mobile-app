// driver view model for the driver page
import 'package:flutter/foundation.dart';
import '../models/delivery_model.dart';
import '../models/driver_model.dart';
import '../models/item_model.dart';
import '../services/driver_service.dart';

class DriverViewModel extends ChangeNotifier {
  late String _uuid;
  late Driver _driver;
  late bool _loading;
  late bool _loading_deliveries;
  late bool _loading_items;
  late DriverService driverService;
  late List<Delivery> _deliveryList;
  late List<Delivery> _displayList;
  late String _currentListTitle;
  late List<Item> _currentItemList;
  late Delivery _currentDelivery;
  late List<Item> _allItems;
  late int itemsCount;

  DriverViewModel() {
    _uuid = "";
    _driver = Driver();
    _loading = true;
    _loading_deliveries = true;
    driverService = DriverService();
    _deliveryList = [];
    _displayList = [];
    _currentListTitle = 'Deliveries';
    _currentItemList = [];
    _currentDelivery = Delivery();
    _allItems = [];
    itemsCount = 0;
    _loading_items = true;
  }

  String get uuid => _uuid;

  Driver get driver => _driver;

  List<Delivery> get deliveryList => _deliveryList;
  int get deliveryListCount => _deliveryList.length;

  List<Delivery> get displayList => _displayList;
  int get displayListLength => _displayList.length;

  String get currentListTitle => _currentListTitle;

  List<Item> get currentItemList => _currentItemList;
  int get currentItemListLength => _currentItemList.length;

  Delivery get currentDelivery => _currentDelivery;

  List<Item> get allItems => _allItems;

  bool get loadingItems => _loading_items;

  // You are not 5m near address, please double check that you are?
  //

  // Finish? Notify customer when

  set currentListTitle(String value) {
    _currentListTitle = value;
    notifyListeners();
  }
  //GOOGLE MAP API => AIzaSyD6O4fG6KI0TTi_5gMENiOb_terHb9sb2E

  Future<void> getDriver() async {
    _driver = await driverService.getDriver(_uuid);
    _loading = false;
    notifyListeners();
  }

  Future<void> getItems(Delivery delivery) async {
    if (delivery.items == null || delivery.items!.isEmpty) {
      print("NO ITEMS");
      return;
    }

    List<Item> temp = [];
    for (var item in delivery.items!) {
      var currentItem = await driverService.getItem(item);
      temp.add(currentItem);
    }

    _currentItemList = temp;
    print(_currentItemList[0].name);
    notifyListeners();
  }

  Future<void> getTopItem() async {
    Delivery delivery = _displayList[0];
    if (delivery.items == null || delivery.items!.isEmpty) {
      print("NO ITEMS");
      return;
    }

    List<Item> temp = [];
    for (var item in delivery.items!) {
      var currentItem = await driverService.getItem(item);
      temp.add(currentItem);
    }

    _currentItemList = temp;

    _currentDelivery = delivery;
    //print(_currentItemList[0].name);
    notifyListeners();
  }

  Future<void> updateItem(itemID, type) async {
    switch (type) {
      case 'scanned':
        await driverService.updateItem(itemID, 'scanned');
        break;
      case 'completed':
        await driverService.updateItem(itemID, 'completed');
        break;
      default:
        break;
    }
  }

  // set delivery status to completed
  Future<void> updateDelivery(deliveryID, status) async {
    await driverService.updateDelivery(deliveryID, status);
    currentDelivery.status = status;
    notifyListeners();
  }

  Future<void> getDeliveries() async {
    //_deliveryList = await driverService.getAllDeliveries();
    _deliveryList =
        await driverService.getAllDeliveriesByDriver("michelle-vasconcelos@email.com");
    setDisplayList("todo");
    _loading_deliveries = false;
    notifyListeners();
  }

  // count completed deliveries
  int get completedDeliveriesCount {
    int count = 0;
    for (Delivery delivery in _deliveryList) {
      if (delivery.status == 'completed') {
        count++;
      }
    }
    return count;
  }

  // get canceled delivery count
  int get canceledDeliveriesCount {
    int count = 0;
    for (Delivery delivery in _deliveryList) {
      if (delivery.status == 'canceled') {
        count++;
      }
    }
    return count;
  }

  void setDisplayList(String type) {
    switch (type) {
      case "in_progress":
        _displayList = _deliveryList
            .where((delivery) => delivery.status == "in_progress")
            .toList();
        break;
      case "completed":
        _currentListTitle = "Completed Deliveries";
        _displayList = _deliveryList
            .where((delivery) => delivery.status == "completed")
            .toList();
        break;
      case "canceled":
        _currentListTitle = "Canceled Deliveries";
        _displayList = _deliveryList
            .where((delivery) => delivery.status == "canceled")
            .toList();
        break;
      default:
        _currentListTitle = "Todo Deliveries";
        _displayList = _deliveryList
            .where((delivery) =>
                delivery.status == null ||
                delivery.status == "todo" ||
                delivery.status == "scanned" ||
                delivery.status == "started")
            .toList();
    }
    notifyListeners();
  }

  // set item status to scanned
  Future<void> setItemsStatus(itemID, status) async {
    await driverService.updateItemStatus(itemID, status);
    notifyListeners();
  }

  // go through all items and set status to not ready
  Future<void> setItemsNotReady() async {
    for (var i in _deliveryList) {
      for (var j in i.items!) {
        //  await driverService.updateItemStatus(j, "not_ready");
        print("${j} set to not ready");
      }
    }
    //notifyListeners();
  }

  // update item status
  Future<void> updateItemStatus(itemID, status) async {
    await driverService.updateItemStatus(itemID, status);
    notifyListeners();
  }

  // check all items that are not_ready
  Future<void> getAllItems() async {
    int count = 0;
    for (var i in _deliveryList) {
      for (String j in i.items!) {
        count += 1;
      }
    }
    if (count != 0 && count != _allItems.length) {
      for (var i in _deliveryList) {
        for (String j in i.items!) {
          Item item = await driverService.getItem(j);
          print("status: ${item.status}");
          if (item.status != null) {
            item.setCustomerName(i.name!);
            // if item not in allItems, add it

            _allItems.add(item);
          }
        }
      }
    }
    _loading_items = false;
    //itemsCount = _allItems.length;
    notifyListeners();
  }

  void setDriver(String uuid) {
    _uuid = uuid;
    //_loading = false;
    // driverService.getDriver(_uuid).then((driver){
    //   _uuid = uuid;
    //   _driver = driver;
    //   _dataLoaded = false;
    //   notifyListeners();
    // });
    //print("done");
    notifyListeners();
  }

  set uuid(String uuid) {
    _uuid = uuid;
    notifyListeners();
  }

  bool get loading {
    return _loading;
  }
}
