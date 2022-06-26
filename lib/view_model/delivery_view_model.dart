
// driver view model for the driver page
import 'package:flutter/foundation.dart';
import '../models/driver_model.dart';
import '../services/driver_service.dart';

class DeliveryViewModel extends ChangeNotifier {
  late String _uuid;
  late Driver _driver;
  late bool _loading;
  late DriverService driverService;

  DeliveryViewModel() {
    _uuid = "";
    _driver = Driver();
    _loading = true;
    driverService = DriverService();
  }

  String get uuid => _uuid;
  
  Driver get driver => _driver;

  Future<void> getDriver() async{
    _driver= await driverService.getDriver(_uuid);
    _loading = false;
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