// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/widgets//navbar.dart';
import 'package:flutter/material.dart';



class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {

  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  // TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Index 0: Home',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 1: Business',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 2: School',
  //     style: optionStyle,
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text("FIX")
      ),
      drawer: NavBar(),
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(25,50,25,25),
          child: Center(

            child: Column(
                children: <Widget>[
                  Image.asset('assets/Car_Pic.png',width: 300),
                  Padding(padding: EdgeInsets.only(top:20)),
                  Text('User',style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                  Text(
                    'Fix & Fill'.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height:20),
                  MaterialButton(
                    onPressed: (){

                      FirebaseAuth.instance.signOut();

                      // }


                      // LoginController.instance.login(controller.email.text.trim(), controller.password.text.trim());

                    },
                    minWidth: double.infinity,
                    height: 50,

                    child: Text('Logout'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,

                  ),



                ]
            ),

          ),
        ),
      ),bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.car_crash),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Orders',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[400],
      onTap: _onItemTapped,
    ),



    );

  }}