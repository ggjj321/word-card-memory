import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WordsCard extends StatefulWidget {
  const WordsCard({Key? key}) : super(key: key);

  @override
  _WordsCardState createState() => _WordsCardState();
}

class _WordsCardState extends State<WordsCard> {

  createWordCard(message){
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(100),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: SizedBox(
          width: 700,
          height: 500,
          child: Text(
            "$message",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }

  int wordIndex = 0;
  int cardType = 0;
  int cardNum = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("word cards"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('wordCards').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {

                if (snapshot.hasError) {
                  createWordCard("wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  var docs = snapshot.data;
                  if(docs == null){
                    createWordCard("null data");
                  }
                  else{
                    cardNum =  docs.docs.length;
                    String context = "";
                    if(wordIndex >= cardNum)wordIndex-=1;
                    if(cardType == 0){
                      context = docs.docs[wordIndex]['word'];
                    }else{
                      context = docs.docs[wordIndex]['meaning'];
                    }
                    return Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(100),
                        onTap: () {
                          if(cardType==0){
                            cardType=1;
                          }else{
                            cardType=0;
                          }
                          setState(() {
                          });
                        },
                        child: SizedBox(
                          width: 700,
                          height: 500,
                          child: Text(
                            '$context',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }
                return createWordCard("loading");
              },
            ),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  if(wordIndex!=0)wordIndex-=1;
                  cardType = 0;
                  setState(() {});
                },
                child: const Text('last'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  wordIndex+=1;
                  cardType = 0;
                  setState(() {});
                },
                child: const Text('next'),
              ),
            ]),
            SizedBox(
              height: 10.0,
            ),
            ArgonButton(
              height: 50,
              width: 350,
              borderRadius: 5.0,
              color: Colors.indigoAccent,
              child: const Text(
                "Sign out",
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
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
