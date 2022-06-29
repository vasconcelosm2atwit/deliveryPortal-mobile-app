import 'package:deliveryportal_driver_app/view_model/driver_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    /// create a login page
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 12),
                  //   child: Image.asset("assets/icons/logo.png"),
                  // ),
                  Expanded(child: Container()),
                ],
                ),
                const SizedBox(
                  height: 30,
                ) ,
                Row(
                children: [
                  Text("Login",
                      style: GoogleFonts.roboto(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Please Login to start deliveries.",
                      style: GoogleFonts.roboto(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "abc@domain.com",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),const SizedBox(
                height: 15,
              ),
              TextField(
                controller: passController,
                //onChanged: (value) => setState() => password = value,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "123",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                   final user = await _authService.signInWithEmailPassword(emailController.text, passController.text);
                   
                   if(user != null){
                    Provider.of<DriverViewModel>(context, listen: false).setDriver(user.uid);
                   }
                   //Provider.of<DriverViewModel>(context, listen: false)
                   //Provider.of<DriverViewModel>(context, listen: false).getDriver();
                  // if (user != null) {
                  //   Provider.of<DriverViewModel>(context, listen: false).uuid = user.uid;
                    
                  // }
                  
                },
                // onTap: () {
                //   print("starting login");
                //   signInWithEmailPassword(
                //           emailController.text, passController.text)
                //       .then((result) {
                //         print("result: ");
                //         print(result);
                //     if (result != null) {
                //       print("logged in!!");
                //       print(result);
                //       //Get.offAllNamed(rootRoute);
                //       Navigator.pushNamed(context, '/home');
                //     } else {
                //       void showAlertMethod(BuildContext context) {
                //         var alert = AlertDialog(
                //           title: const Text('Login Failed'),
                //           content: const Text(
                //               'Username and/or Password are incorrect'),
                //           actions: <Widget>[
                //             TextButton(
                //               onPressed: () => Navigator.pop(context, 'OK'),
                //               child: const Text('OK'),
                //             ),
                //           ],
                //         );

                //         showDialog(
                //             context: context,
                //             builder: (BuildContext context) {
                //               return alert;
                //             });
                //       }

                //       showAlertMethod(context);
                //     }
                //   }).catchError((error) {
                //     print('Registration Error: $error');
                //   });
                //   // Get.offAllNamed(rootRoute);
                //   //Get.offAll(() => SiteLayout());
                //   // print("ended test with");
                //   // print(emailController.text);
                //   // print(passController.text);
                // },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("Login",
                      style: GoogleFonts.roboto(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
                //Text('Login Page'),
                // TextButton(
                //   child: Text('Login'),
                //   onPressed: () {
                //     Navigator.pushNamed(context, '/home');
                //   },
                // ),
              ],
            ),
          )
        )

      ),
    
    );
  }
}