import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:st/dataDisplay.dart';
import 'package:st/regForm.dart';
import 'package:st/auth.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:st/wrapper.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  /// initializing the firebase app
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyAEAujsc2VDIO5BUvFr5frpQbYLivbpxPM',
        appId: '1:37013955548:web:b30aed2bc90bcf1597a519',
        messagingSenderId: '37013955548',
        projectId: 'smart-teachers-8b97d',
        storageBucket: 'smart-teachers-8b97d.appspot.com',   ));
  FirebaseFirestore.instance.settings=const Settings(
    persistenceEnabled: true,
  );
  runApp(MaterialApp(home:HomePage()));
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Wrapper();
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  final uMail=TextEditingController();
  final uPswd=TextEditingController();
  final auth=authService();

  @override
  void dispose(){
    super.dispose();
    uMail.dispose();
    uPswd.dispose();
  }
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
                    padding: EdgeInsets.only(top:210),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 180,left: 10),
                          child: Text('Smart',  style: TextStyle(fontSize: 60,fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 100,left: 10),
                          child: Text('Teachers',  style: TextStyle(fontSize: 60,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: TextField(
                    controller: uMail,
                    decoration: InputDecoration(
                        hintText: 'Enter Email ID',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: TextField(
                    controller: uPswd,
                    decoration: InputDecoration(
                        hintText: 'Enter Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                ),
                SizedBox(height:10),
                Container(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if(uMail.text.isEmpty|| uPswd.text.isEmpty)
                          {
                                Fluttertoast.showToast(
                                msg: "Please Fill Credentials",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                                return;
                          }
                        login();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(milliseconds: 250),
                            content: Text("Please Wait"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),

                      child: Text('Login',style: TextStyle(fontSize: 17,color: Colors.white),)

                  ),
                ),
                SizedBox(height: 100,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text('Dont Have an account? '),
                    ),
                    InkWell(
                      child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.w900),),
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>regF())
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
  login() async{
    final user=await auth.login(uMail.text, uPswd.text);
    if(user!=null)
      {
        log('user logged in');
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>MainPage()));
      }
    else
      {
          Fluttertoast.showToast(
              msg: "Your Email or Password might be wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 16.0
          );
          return;
      }
  }
}

