import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordCardInformation extends ChangeNotifier{
  CollectionReference wordCards =
      FirebaseFirestore.instance.collection('wordCards');

  String? cardWord;
  int? cardNum;
  var firebaseStorage;
  int cardIndex = 0;

  WordCardInformation(){
    setInformation();
  }

  void nextCard(){
    if(cardNum != null){
      cardIndex = cardIndex + 1 < cardNum! ? cardIndex + 1 : cardIndex;
      notifyListeners();
    }
  }

  void lastCard(){
    if(cardNum != null){
      cardIndex = cardIndex - 1 > -1 ? cardIndex - 1 : cardIndex;
      notifyListeners();
    }
  }

  void setInformation() async{
    firebaseStorage = await FirebaseFirestore.instance.collection('wordCards').get();
    cardNum = firebaseStorage.docs.length;
    cardIndex = 0;
    notifyListeners();
  }

  String getCardType(String cardType) => cardType == "word" ? "meaning" : "word";

  String getWord(String cardType) {
    if(firebaseStorage != null) {
      if (cardType == "word") {
        cardWord= firebaseStorage.docs[cardIndex]['word'];
      } else {
        cardWord = firebaseStorage.docs[cardIndex]['meaning'];
      }
    }
    return cardWord ??"loading";
  }
}