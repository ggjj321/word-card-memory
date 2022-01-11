import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flip_card/flip_card.dart';
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
            FlipCard(
              fill: Fill.fillBack,
              // Fill the back side of the card to make in the same size as the front.
              direction: FlipDirection.HORIZONTAL,

              front: Card(
                child: SizedBox(
                  width: 500,
                  height: 300,
                  child: Column(
                    children: [
                      Consumer<WordCardInformation>(
                          builder: (context, wordCardInformation, child) {
                        return Text(
                          '\n\n${wordCardInformation.getWord("word")}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        );
                      }),
                      Text(
                        '\n\nclick the card to check meaning',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              back: Card(
                child: SizedBox(
                  width: 500,
                  height: 300,
                  child: Column(
                    children: [
                      Consumer<WordCardInformation>(
                          builder: (context, wordCardInformation, child) {
                            return Text(
                              '\n\n${wordCardInformation.getWord("meaning")}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            );
                          }),
                      Text(
                        '\n\nclick the card to check meaning',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
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
