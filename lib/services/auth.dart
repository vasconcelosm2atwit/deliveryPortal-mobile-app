import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
String? uid;
String? userEmail;

Future signIn(String? email,String? password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
}

/// sign out current user
Future signOut() async {
  await FirebaseAuth.instance.signOut();
}


Future<User?> signInWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided.');
    }
  }

  return user;
}