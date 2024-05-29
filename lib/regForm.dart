import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:st/auth.dart';
import 'package:st/main.dart';
class regF extends StatefulWidget {
  const regF({super.key});

  @override
  State<regF> createState() => _regFState();
}

class _regFState extends State<regF> {
  final uMail=TextEditingController();
  final uPswd=TextEditingController();
  final uName=TextEditingController();
  final auth=authService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orangeAccent,
              Colors.white30
            ]
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:100.0,right: 170),
                child: Center(
                    child: Text('Sign Up ',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 40),
                    )
                ),
              ),
              SizedBox(height: 50,),
              SizedBox(
                height: 50,
                width: 300,
                child: TextField(
                  controller: uName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: 300,
                child: TextField(
                  controller: uMail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: 300,
                child: TextField(
                  controller: uPswd,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Create Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19)
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 100,),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed:(){
                    if(uName.text.isEmpty|| uMail.text.isEmpty|| uPswd.text.isEmpty)
                    {
                          Fluttertoast.showToast(
                          msg: "Please Fill Details",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return;
                    }
                     return _signup();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text('Next',style: TextStyle(fontSize:20,color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  _signup() async{
    final user= await auth.createUserWithEmail(uMail.text, uPswd.text);
    if(user!=null)
      {
        log('user created successfully!');
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context)=>HomePage()));
        Navigator.pop(context);
      }
  }
}
