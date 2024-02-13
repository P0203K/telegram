import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegram/screen/home.dart';

class PhoneVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  PhoneVerifyScreen({required this.phoneNumber});

  @override
  State<StatefulWidget> createState() => PhoneVerifyScreenState();
}

class PhoneVerifyScreenState extends State<PhoneVerifyScreen>{
  var phoneCt = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            child: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,),
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
              Container(height: 30,),
              Text(
                widget.phoneNumber,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                textDirection: TextDirection.ltr,
              ),
              Container(height: 15,),
              const Text('We just sent you an SMS with the code.', textAlign: TextAlign.center, textDirection: TextDirection.ltr,),
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
                      hintText: 'Code'
                  ),
                ),
              ),
              Container(height: 50,),
              TextButton(
                onPressed: (){},
                child: const Text("+Haven't received the code?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.blue),textDirection: TextDirection.ltr,),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
