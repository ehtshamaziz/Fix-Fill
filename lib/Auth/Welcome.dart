import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Auth//signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/login_controller.dart';


class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {


  String selectedOption = 'User';
  List<String> dropdownOptions = ['User', 'Admin', 'Station', 'Rider'];
  final controller=Get.put(LoginController());
  final _formkey=GlobalKey<FormState>();
  String error="";

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(25,50,25,25),
            child: Center(
              child:Form(
                key: _formkey,
              child: Column(
                  children: <Widget>[
                    Image.asset('assets/Car_Pic.png',width: 250),
                    const Padding(padding: EdgeInsets.only(top:50)),
                    Text('Login',style: TextStyle(
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
                    DropdownButton<String>(
                      // initialSelection: dropdownOptions.first,
                        value: selectedOption,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption = newValue!;
                          });
                        },
                        items: dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()),
                    TextFormField(
                        controller: controller.email,
                      decoration:InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0,15.0,20.0,15.0),
                        labelText:"Email",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),

                          ),focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      )

                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        final emailRegExp = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null; // Return null if the input is valid
                      },

                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: controller.password,
                        obscureText: true,
                        decoration:InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(20.0,15.0, 20.0,15.0),
                            labelText:"Password",
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),

                            ),focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0),
                        )


                        ),


                    ),
                    SizedBox(height: 20),
                    if(error != "")
                      Text(
                        error! as String,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ,
                    SizedBox(height: 10),

                    MaterialButton(
                      onPressed: () async {
    if (_formkey.currentState!.validate()) {


      String? err= await LoginController.instance.login(controller.email.text.trim(), controller
          .password.text.trim(), selectedOption);
      setState(() {

        error = err!;
      });
    }
                      },
                      minWidth: double.infinity,
                      height: 50,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,

                      child: Text('Login'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                      )),


                    ),

                    const SizedBox(height: 20),

                    const Text('OR',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                    Row(
                      children: [

                        const Padding(padding: EdgeInsets.only(left:70)),
                        const Text('Dont have an account?',style:TextStyle(


                        )),
                        const Padding(
                          padding: EdgeInsets.only(left: 0), // Adjust the padding as needed
                        ),
                        MaterialButton(
                          onPressed: () {
                            // handleSumbit()
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>signup(),)
                              ,);
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>main(),)
                            //   ,);
                          },
                          height: 10,
                          textColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.only(left:10),
                          minWidth: 50,
                          child: const Text('Sign up',style: TextStyle(
                            fontSize: 18,
                          )),
                        )],
                    )


                  ]
              ),
              ),
            ),
          ),
        )

    );
  }
}
