import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telegram/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerifyScreen extends StatefulWidget {
  String verificationId;
  // String phoneNumber;

  // PhoneVerifyScreen(this.phoneNumber, this.verificationId)
  PhoneVerifyScreen({super.key, required this.verificationId});

  @override
  State<StatefulWidget> createState() =>
      PhoneVerifyScreenState( verificationId);
}

class PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  var codeCt = TextEditingController();

  String? verificationId;
  // String phoneNumber;
  PhoneVerifyScreenState(this.verificationId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Back',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                // Create PhoneAuthCredential using the verification ID and SMS code
                PhoneAuthCredential credential =
                    await PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: codeCt.text.toString());

                // Sign in the user with the PhoneAuthCredential

                UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential).then((value){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                });

                return credential;
              } catch (ex) {
                print(ex.toString());
              }


            },
            child: const Text(
              "Next",
              style: TextStyle(fontWeight: FontWeight.bold),
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Spacer(),
              const Spacer(),
              Container(
                height: 30,
              ),
              Text(
                "+919867506341",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textDirection: TextDirection.ltr,
              ),
              Container(
                height: 15,
              ),
              const Text(
                'We just sent you an SMS with the code.',
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
              Container(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: codeCt,
                  maxLength: 12,
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: 'Code'),
                ),
              ),
              Container(
                height: 50,
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "+Haven't received the code?",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue),
                  textDirection: TextDirection.ltr,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // //Verify phone authentication with SMS code
  // void verifyPhoneAuth(String smsCode) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //     verificationId: verificationId!,
  //     smsCode: smsCode,
  //   );
  //
  //   await auth.signInWithCredential(credential);
  //   var user = auth.currentUser;
  //   if (user != null) {
  //     print("Login Success");
  //   } else
  //     print("Login Failed");
  // }
}
