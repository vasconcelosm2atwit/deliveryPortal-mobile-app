
// create a login view model for the login page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/driver_model.dart';
import '../services/auth.dart';

class LoginViewModel extends ChangeNotifier{
  String? email;
  String? password;
  Driver? driver;
  // LoginViewModel({
  //   this.email,
  //   this.password,
  // });

  // sign in with email and password
  Future<void> signIn(email,password) async{
    User? currentDriver = await signInWithEmailPassword(email,password);
    if(currentDriver != null){
      email = currentDriver.email;
    }
    notifyListeners();
  }  

}