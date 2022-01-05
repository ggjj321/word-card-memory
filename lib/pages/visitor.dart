import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'create_account.dart';
import 'words_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class vistorPage extends StatefulWidget {
  const vistorPage({Key? key}) : super(key: key);
  static const routeName = '/vistor';

  @override
  _vistorPageState createState() => _vistorPageState();
}

class _vistorPageState extends State<vistorPage> {
  FirebaseAuth auth = FirebaseAuth.instance;


  void conditionDialog(condition){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('sign in error'),
            content: Text(condition),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ok'),
              )
            ],
          );
        });
  }

  void signIn(email, psd)async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: psd
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WordsCard()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        conditionDialog('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        conditionDialog('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    late TextEditingController emailController = TextEditingController();
    late TextEditingController psdController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("vistor page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(150),
                child : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  <Widget>[
                    SizedBox(
                      width: 500.0,
                      height: 100.0,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                              ),
                            ),
                            labelText: 'email',
                            hintText: 'Enter your User email'
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 500.0,
                      height: 100.0,
                      child: TextField(
                        controller: psdController,
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                              ),
                            ),
                            labelText: 'Password',
                            hintText: 'Enter your secure password'
                        ),
                      ),
                    ),
                    ArgonButton(
                      height: 50,
                      width: 350,
                      borderRadius: 5.0,
                      color: Color(0xFF7866FE),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      loader: Container(
                        padding: EdgeInsets.all(10),
                        child: SpinKitRotatingCircle(
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                      onTap: (startLoading, stopLoading, btnState) {
                        if(btnState == ButtonState.Idle){
                          signIn(emailController.text, psdController.text);
                          emailController.clear();
                          psdController.clear();
                        }
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateNewAccount()),
                        );
                      },
                      child: const Text('Create new Account'),
                    ),
                  ],
                )
            ),
          ],
        ),
      )
    );
  }
}