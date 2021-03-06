// driver view model for the driver page
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../models/delivery_model.dart';
import '../models/driver_model.dart';
import '../models/item_model.dart';
import '../services/driver_service.dart';
import 'package:open_route_service/open_route_service.dart';

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
  late Position _currentPosition;
  late double _curDist;
  late int _curDistTime;
  List<OptimizationRoute>? _outputDist;

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
    _curDist = 0;
    _curDistTime = 0;
    _loading_items = true;
  }

  String get uuid => _uuid;

  Driver get driver => _driver;
  Position get currentPosition => _currentPosition;

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

  double get curDist => _curDist;
  int get curDistTime => _curDistTime;

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
    await distanceInfoToLoc();
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
    _deliveryList = await driverService
        .getAllDeliveriesByDriver("michelle-vasconcelos@email.com");

    int count = 0;
    for (var delivery in _deliveryList) {
      // print(delivery.address);
      count = count + 1;
      if (count % 2 == 0) {
        delivery.instructions =
            "Drop by the door, don't ring the door bell please!";
      }
      delivery.step_id = count;
      delivery.latlng = await latlongFromAddress(delivery.address.toString());
      //print(delivery.latlng);
    }

    _deliveryList = await routingOptimzation(_deliveryList);

    setDisplayList("todo");
    for (var delivery in _displayList) {
      print(delivery.instructions);
      print(delivery.step_id);
    }
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
    _displayList.sort((a, b) => a.deliveryStep!.compareTo(b.deliveryStep!));
    notifyListeners();
  }

  // set item status to scanned
  Future<void> setItemsStatus(itemID, status) async {
    for (var item in _allItems) {
      if (item.id == itemID) {
        item.status = status;
      }
    }
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
    for (var item in _allItems) {
      if (item.id == itemID) {
        item.status = status;
      }
    }
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

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    print(permission);

    notifyListeners();
  }

  Future<void> determineCurrentPosition() async {
    _currentPosition = await _determinePosition();
    debugPrint(_currentPosition.toString());
    notifyListeners();
  }

  Future<void> checkDistanceBetween(List<double> latlong) async {
    // _currentPosition = await _determinePosition();
    //AIzaSyD6O4fG6KI0TTi_5gMENiOb_terHb9sb2E
    // GeoData data = await Geocoder2.getDataFromAddress(
    //     address: "92 devon street, boston, MA",
    //     googleMapApiKey: "AIzaSyD6O4fG6KI0TTi_5gMENiOb_terHb9sb2E");
    // print(data.address);
    // print(data.latitude);
    // print(data.longitude);
    // print(data.street_number);
    //Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude)
    var current_pos = await _determinePosition();
    double distance = Geolocator.distanceBetween(
        current_pos.latitude, current_pos.longitude, latlong[0], latlong[1]);
  }

  Future<void> optimizationAddress() async {
    for (var data in _outputDist!) {
      for (var step in data.steps!) {
        print("step_id: ${step.id}");
        print("type: ${step.type}");
        print("arrival: ${step.arrival}");
        print("duration: ${step.duration}");
        String address = await addressesFromLatLng(
            step.location.latitude, step.location.longitude);
        print("address: $address");
        print("-----------------------------------------------------");
      }
    }
  }

  Future<String> addressesFromLatLng(double lat, double lng) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: lat,
        longitude: lng,
        googleMapApiKey: "AIzaSyD6O4fG6KI0TTi_5gMENiOb_terHb9sb2E");

    return data.address;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> testAddress() async {
    GeoData data = await Geocoder2.getDataFromAddress(
        address: "200 pearl street, Boston, MA",
        googleMapApiKey: "AIzaSyD6O4fG6KI0TTi_5gMENiOb_terHb9sb2E");
    print(data.address);
  }

  Future<List<double>> latlongFromAddress(String fromAddress) async {
    print("starting: $fromAddress");
    try {
      GeoData data = await Geocoder2.getDataFromAddress(
          address: fromAddress,
          googleMapApiKey: "AIzaSyD6O4fG6KI0TTi_5gMENiOb_terHb9sb2E");
      print("ran this through for address $fromAddress");
      print({
        "latitude": data.latitude,
        "longitude": data.longitude,
      });
      return [data.latitude, data.longitude];
    } catch (e) {
      print(e);
    }
    return [];
    // print(data.address);
    // print(data.latitude);
    // print(data.longitude);
    // print(data.street_number);
  }

  void printDeliveries() {
    for (var delivery in _displayList) {
      print(delivery.step_id);
      print(delivery.deliveryStep);
      print(delivery.address);
    }
  }

  Future<List<Delivery>> routingOptimzation(List<Delivery> deliveries) async {
    final OpenRouteService client = OpenRouteService(
        apiKey: '5b3ce3597851110001cf6248f451b71dbef74a92872cf209dbec6120',
        profile: ORSProfile.drivingCar);
    List<double> home = [42.309490, -71.078680];
    print("----");
    for (var delivery in deliveries) {
      print("step_id: ${delivery.step_id}");
      print(delivery.deliveryStep);
      print(delivery.address);
    }
    List<VroomJob> jobs = [];
    List<int>? DeliveryIDs = [1];
    for (var i in deliveries) {
      if (i.latlng!.isNotEmpty) {
        jobs.add(VroomJob(
            id: i.step_id!,
            location:
                ORSCoordinate(latitude: i.latlng![0], longitude: i.latlng![1]),
            service: 300,
            skills: [1],
            amount: [1]));
      }
    }

    List<VroomVehicle> vehicles = [];
    VroomVehicle vehicle = VroomVehicle(
        id: 1,
        start: ORSCoordinate(latitude: home[0], longitude: home[1]),
        end: ORSCoordinate(latitude: home[0], longitude: home[1]),
        capacity: [5],
        skills: [1]);
    vehicles.add(vehicle);

    OptimizationData output =
        await client.optimizationDataPost(jobs: jobs, vehicles: vehicles);

    for (var route in output.routes) {
      int start = 0;
      for (var step in route.steps!) {
        for (var delivery in deliveries) {
          if (delivery.step_id == step.id) {
            start = start + 1;
            delivery.deliveryStep = start;
          }
        }
      }
    }
    print("----");
    for (var delivery in deliveries) {
      print("step_id: ${delivery.step_id}");
      print(delivery.deliveryStep);
      print(delivery.address);
    }
    print("----");
    notifyListeners();

    return deliveries;
    // setup all the latlongs for the deliveries, then setup the step for each delivery throught eh opt
  }

  Future<void> distanceInfoToLoc() async {
    final OpenRouteService client = OpenRouteService(
        apiKey: '5b3ce3597851110001cf6248f451b71dbef74a92872cf209dbec6120',
        profile: ORSProfile.drivingCar);

    var current_location = await _determinePosition();
    // Example coordinates to test between
    // print("current_location: $current_location");
    // print(" delivery_location: ${_currentDelivery.latlng.toString()}");
    double startLat = current_location.latitude;
    double startLng = current_location.longitude;
    double endLat = _currentDelivery.latlng![0];
    double endLng = _currentDelivery.latlng![1];

    // Form Route between coordinates
    // final List<ORSCoordinate> routeCoordinates =
    //     await client.directionsRouteCoordsGet(
    //   startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
    //   endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
    // );

    // 26min 17.6 mil
    // 26491.6, 1811.6 = duration

    GeoJsonFeatureCollection cord = await client.directionsRouteGeoJsonGet(
        startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
        endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng));

    double dist = cord.features[0].properties['summary']['distance'];
    double distance = convertKmsToMiles(dist);
    double t = cord.features[0].properties['summary']['duration'];
    Duration cur = Duration(seconds: t.toInt());
    int time = cur.inMinutes;

    _curDist = distance;
    _curDistTime = time;
    notifyListeners();
    // cord.features.forEach((element) {
    //   print(element.properties);
    //   print(element.properties['summary']['distance']);
    //   print(element.properties['summary']['duration']);
    //   Duration cur =
    //       Duration(seconds: element.properties['summary']['duration'].toInt());
    //   print("Minutes in minutes: ${cur.inMinutes}");
    //   print(
    //       "Distance in miles: ${convertKmsToMiles(element.properties['summary']['distance'])}");
    // });
    // Print the route coordinates
    // print("route coordinates: ");
    // routeCoordinates.forEach(print);
    // print("------------OPTIMIZATION------------------");
    // List<double> home = [42.309490, -71.078680];
    // List<double> school = [42.337255, -71.096552];
    // List<double> ben = [42.331047, -71.117715];
    // List<double> newyork = [40.730610, -73.935242];
    // List<double> losangeles = [42.315609, -71.112995];

    // List<VroomJob> jobs = [];
    // List<int>? DeliveryIDs = [1];
    // VroomJob job = VroomJob(
    //   id: 1,
    //   location: ORSCoordinate(latitude: home[0], longitude: home[1]),
    //   service: 300,
    //   skills: [1],
    //   amount: [1],
    //   //delivery: DeliveryIDs,
    // );
    // VroomJob job2 = VroomJob(
    //   id: 2,
    //   location: ORSCoordinate(latitude: school[0], longitude: school[1]),
    //   service: 300,
    //   skills: [1],
    //   amount: [1],
    //   //delivery: DeliveryIDs,
    // );
    // VroomJob job3 = VroomJob(
    //   id: 3,
    //   location: ORSCoordinate(latitude: ben[0], longitude: ben[1]),
    //   //delivery: DeliveryIDs,
    //   service: 300,
    //   skills: [1],
    //   amount: [1],
    // );
    // VroomJob job4 = VroomJob(
    //   id: 4,
    //   location: ORSCoordinate(latitude: newyork[0], longitude: newyork[1]),
    //   // delivery: DeliveryIDs,
    //   service: 300,
    //   skills: [14],
    //   amount: [1],
    // );
    // VroomJob job5 = VroomJob(
    //   id: 5,
    //   location:
    //       ORSCoordinate(latitude: losangeles[0], longitude: losangeles[1]),
    //   //delivery: DeliveryIDs,
    //   service: 300,
    //   skills: [14],
    //   amount: [1],
    // );

    // jobs.add(job);
    // jobs.add(job2);
    // jobs.add(job3);
    // jobs.add(job4);
    // jobs.add(job5);

    // List<VroomVehicle> vehicles = [];
    // VroomVehicle vehicle = VroomVehicle(
    //     id: 1,
    //     start: ORSCoordinate(latitude: home[0], longitude: home[1]),
    //     end: ORSCoordinate(latitude: home[0], longitude: home[1]),
    //     capacity: [5],
    //     skills: [1, 14]);
    // vehicles.add(vehicle);

    // OptimizationData output =
    //     await client.optimizationDataPost(jobs: jobs, vehicles: vehicles);

    // _outputDist = output.routes;

    // print("optimaztion data: ");
    // print(output.toJson());
    // print(output.routes);
    // print("---------22222----------------------");
    // JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    // String prettyprint = encoder.convert(output.routes);
    // debugPrint(prettyprint);
  }

  Future<void> sendMessage() async {
    TwilioFlutter twilioFlutter = await TwilioFlutter(
        accountSid:
            'AC38b957061479b4830ef4ec3c86265c0d', // replace *** with Account SID
        authToken:
            'd76954ce79114d098fd0f6ec806783a1', // replace xxx with Auth Token
        twilioNumber: '+12567334284' // replace .... with Twilio Number
        );

    String message =
        "Hello ${_currentDelivery.name}, this is Michelle from TestingCounter. I'll be there in about $_curDistTime minutes with your TC@Home delivery. Thank you!";

    if (_currentDelivery.instructions != null) {
      message += "\n\nDelivery instruction: ${_currentDelivery.instructions}";
    }

    await twilioFlutter.sendSMS(
      toNumber: "6179357426",
      messageBody: message,
    );
  }

  Future<void> getMessage() async {
    TwilioFlutter twilioFlutter = await TwilioFlutter(
        accountSid:
            'AC38b957061479b4830ef4ec3c86265c0d', // replace *** with Account SID
        authToken:
            'd76954ce79114d098fd0f6ec806783a1', // replace xxx with Auth Token
        twilioNumber: '+12567334284' // replace .... with Twilio Number
        );
    await twilioFlutter.getSmsList();
  }

  double convertKmsToMiles(double kms) {
    double miles = 0.000621371 * kms;
    return miles;
  }
}
