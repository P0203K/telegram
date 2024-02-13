import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login/phone_verify_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  var phoneCt = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(alignment: Alignment.topRight, child:
              TextButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PhoneVerifyScreen()));
              },
                child: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,),

              ),),
              const Spacer(),
              SizedBox(
                width: 150,
                child: Image.asset('assets/images/telegram_logo.png'),
              ),
              Container(height: 30,),
              const Text("Your Phone", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textDirection: TextDirection.ltr, ),
              Container(height: 15,),
              const Text('Please confirm your country code \nand enter your phone number.', textAlign: TextAlign.center, textDirection: TextDirection.ltr,),
              Container(height: 30,),
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25),
                child: TextField(

                  textAlign: TextAlign.center,
                  controller: phoneCt,
                  maxLength: 12,
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Your phone number'
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}