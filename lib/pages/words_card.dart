import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_setup_web/model/word_card_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class WordsCard extends StatefulWidget {
  const WordsCard({Key? key}) : super(key: key);

  @override
  _WordsCardState createState() => _WordsCardState();
}

class _WordsCardState extends State<WordsCard> {
  createWordCard(message) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(100),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: SizedBox(
          width: 500,
          height: 300,
          child: Text(
            "\n\n$message",
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
  List<String> type = ["meaning", "word"];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
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
            Card(
              child: InkWell(
                splashColor: Colors.blue.withAlpha(100),
                onTap: () {
                  var wordCardInformation = context.read<WordCardInformation>();
                  wordCardInformation.changeCardType();
                },
                child: SizedBox(
                    width: 500,
                    height: 300,
                    child: Consumer<WordCardInformation>(
                      builder: (context, wordCardInformation, child) {
                        return Column(
                          children: [
                            Text(
                              '\n\n${wordCardInformation.getInformation()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            ),
                            Text(
                              '\n\nclick the card to check ${wordCardInformation.getCardType()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        );
                      },
                    )),
              ),
            ),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  var wordCardInformation = context.read<WordCardInformation>();
                  wordCardInformation.lastCard();
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
                  var wordCardInformation = context.read<WordCardInformation>();
                  wordCardInformation.nextCard();
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
