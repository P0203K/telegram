import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:new_flutter_clone/screen/login/phone_verify_screen.dart';
import 'screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

