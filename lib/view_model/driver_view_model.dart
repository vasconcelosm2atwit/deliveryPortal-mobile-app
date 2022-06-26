
// driver view model for the driver page
import 'package:flutter/foundation.dart';
import '../models/delivery_model.dart';
import '../models/driver_model.dart';
import '../services/driver_service.dart';

class DriverViewModel extends ChangeNotifier {
  late String _uuid;
  late Driver _driver;
  late bool _loading;
  late bool _loading_deliveries;
  late DriverService driverService;
  late List<Delivery> _deliveryList;

  DriverViewModel() {
    _uuid = "";
    _driver = Driver();
    _loading = true;
    _loading_deliveries = true;
    driverService = DriverService();
    _deliveryList = [];
  }

  String get uuid => _uuid;
  
  Driver get driver => _driver;

  List<Delivery> get deliveryList => _deliveryList;

  Future<void> getDriver() async{
    _driver= await driverService.getDriver(_uuid);
    _loading = false;
    notifyListeners();
  }

  Future<void> getDeliveries() async{
    _deliveryList = await driverService.getAllDeliveries();
    _loading_deliveries = false;
    notifyListeners();
  }

  void setDriver(String uuid){
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