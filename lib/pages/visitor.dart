import 'dart:io';

import 'package:firebase_setup_web/model/word_card_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/src/provider.dart';
import 'create_account.dart';
import 'words_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class vistorPage extends StatefulWidget {
  const vistorPage({Key? key}) : super(key: key);
  static const routeName = '/vistor';

  @override
  _vistorPageState createState() => _vistorPageState();
}

class _vistorPageState extends State<vistorPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void conditionDialog(condition) {
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

  void signIn(email, psd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: psd);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WordsCard()),
      );
      var wordCardInformation = context.read<WordCardInformation>();
      wordCardInformation.setInformation();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("vistor page"),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign In to \nmemorize words',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        "If you don't have an account",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        " You can",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateNewAccount()),
                          );
                        },
                        child: Text(
                          "Register here!",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'images/92154744_p0_master1200.jpg',
                    width: 300,
                  ),
                ],
              ),
            ),

            Column(
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
                              hintText: 'Enter email',
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                              labelStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.only(left: 30),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: (Colors.blueGrey[50])!),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: (Colors.blueGrey[50])!),
                                borderRadius: BorderRadius.circular(15),
                              ),
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
                              hintText: 'Password',
                              suffixIcon: Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                              labelStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.only(left: 30),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: (Colors.blueGrey[50])!),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: (Colors.blueGrey[50])!),
                                borderRadius: BorderRadius.circular(15),
                              ),
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
                                fontWeight: FontWeight.w700),
                          ),
                          loader: Container(
                            padding: EdgeInsets.all(10),
                            child: SpinKitRotatingCircle(
                              color: Colors.white,
                              size: 50.0,
                            ),
                          ),
                          onTap: (startLoading, stopLoading, btnState) {
                            if (btnState == ButtonState.Idle) {
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
                              MaterialPageRoute(
                                  builder: (context) => CreateNewAccount()),
                            );
                          },
                          child: const Text(
                            'Create new Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ));
  }
}
