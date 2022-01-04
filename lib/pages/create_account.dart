import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({Key? key}) : super(key: key);

  @override
  _CreateNewAccountState createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late String condition = 'register success';
  void registerMethod(email, passWord) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: passWord);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        condition = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        condition = 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('register condition'),
            content: Text(condition),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('ok'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    late TextEditingController emailController = TextEditingController();
    late TextEditingController passController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("vistor page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 500.0,
                      height: 100.0,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: 'email',
                            hintText: 'Enter your new email'),
                      ),
                    ),
                    SizedBox(
                      width: 500.0,
                      height: 100.0,
                      child: TextField(
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: 'Password',
                            hintText: 'Enter your new secure password'),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.indigo),
                      onPressed: () {
                        registerMethod(
                            emailController.text, passController.text);
                      },
                      child: const Text(
                        "create account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
