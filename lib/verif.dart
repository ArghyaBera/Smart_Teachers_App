import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:st/auth.dart';
import 'package:st/wrapper.dart';
class veriScreen extends StatefulWidget {
  final User user;
  const veriScreen({super.key, required this.user});

  @override
  State<veriScreen> createState() => _veriScreenState();
}

class _veriScreenState extends State<veriScreen> {
  final auth=authService();
  late Timer timer;

  @override
  void initState(){
    super.initState();
    auth.sendLinkEmail();
    timer=Timer.periodic(const Duration(seconds: 5) , (timer){
      FirebaseAuth.instance.currentUser?.reload();
      if(FirebaseAuth.instance.currentUser!.emailVerified==true)
        {
          timer.cancel();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=>Wrapper())
          );
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right:16,left:16,top: 350.0),
            child: Text('An Email has been for verification, Click on the link to verify'),
          ),
          ElevatedButton(
              onPressed:() async{
                auth.sendLinkEmail();
          },
              child: Text('Tap to Resend')
          )
        ],
      ),
    );
  }
}
