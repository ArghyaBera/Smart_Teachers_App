import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:st/auth.dart';
import 'package:st/dataDisplay.dart';
import 'package:st/main.dart';
import 'package:st/verif.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else if(snapshot.hasError){
          return Center(child: Text('Error'),);
        }
        else
          {
            if(snapshot.data==null)
              {
                return LoginScreen();
              }
            else
              {
                if(snapshot.data!.emailVerified==true)
                  {
                    return LoginScreen();
                  }
                return veriScreen(
                  user:snapshot.data!
                );
              }
          }
      },),
    );
  }
}
