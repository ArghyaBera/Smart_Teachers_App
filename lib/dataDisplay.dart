import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:st/auth.dart';
import 'package:st/main.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class datad extends StatefulWidget {
  const datad({super.key});

  @override
  State<datad> createState() => _datadState();
}

class _datadState extends State<datad> {
  final auth = authService();

  DateTime? _selectedDate;
  String? dob;
  final  _name = TextEditingController();
  String? gender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // current date
      firstDate: DateTime(1900), // earliest allowable date
      lastDate: DateTime(2101), // latest allowable date
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });

      // Convert pickedDate to a formatted string
      dob = DateFormat.yMMMMd('en_US').format(pickedDate);
    }
  }


  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMMd('en_US'); //

    return Scaffold(
      body: Container(

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:40),
              Container(
                margin: EdgeInsetsDirectional.only(top: 12,start:25),
                child: Text('Welcome to Smart Teachers',
                  style:TextStyle(fontWeight: FontWeight.bold,fontSize: 35) ,),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 240,),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      await auth.signout();
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:30,right: 280.0),
                child: Text('Name', style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 50,
                width: 330,
                child: TextField(
                  controller: _name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(right: 280),
                child: Text('DOB',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
              ),
              SingleChildScrollView(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: Text(
                        dob == null
                            ? 'No date chosen!'
                            : 'Picked Date: ${dob}',
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date', style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(right: 200.0),
                child: Text('Select Gender',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 150.0),
                child: DropdownButton<String>(
                  value: gender,
                  hint: Text('Choose Gender',),
                  items: <String>['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 50,),
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async{
                      String id=randomAlphaNumeric(10);
                      Map<String,dynamic>studDet={
                        "Name":_name.text,
                        "DOB": dob,
                        "Gender": gender,
                      };
                      if (_name.text.isEmpty || dob == null || gender == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill in all fields."),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      await datab().addStudDetail(studDet, id);
                        Fluttertoast.showToast(
                            msg: "Student details have been added",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    child: Text('Add',style: TextStyle(fontSize: 17,color: Colors.orangeAccent),)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class EmptyPage extends StatefulWidget {
  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  Stream? studStream;

  getontheload()async{
    studStream=await datab().getDetails();
    setState(() {

    });
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }
  Widget allStudDetail(){
  return StreamBuilder(
    stream: studStream,
      builder: (context, AsyncSnapshot snapshot){
    return snapshot.hasData? ListView.builder(
      itemCount: snapshot.data.docs.length,
        itemBuilder: (context,index){
        DocumentSnapshot ds=snapshot.data.docs[index];
        return Card(
          shadowColor: Colors.orange,
          surfaceTintColor: Colors.orange,
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //     color: Colors.white54,
            //     // borderRadius: BorderRadius.circular(100),
            // ),
            child: Column(
              children: [
                // SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(top:10,right: 170.0),
                  child: Text('Name: '+ds["Name"], style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 120.0),
                  child: Text('DOB: '+ds["DOB"], style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 150.0,bottom: 20),
                  child: Text('Gender: '+ds["Gender"], style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  ),
                )
              ],
            ),
          ),
        );
        })
        :Container();
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                  child: Text('All Students Detail',
                    style: TextStyle(
                        fontSize: 35,fontWeight: FontWeight.bold,
                    ),
              )
              ),
            ),
            Expanded(child: allStudDetail())
          ],
        ),
      )
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    datad(),
    EmptyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add New Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "Student's Data",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

