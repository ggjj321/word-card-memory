import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordCardInformation extends ChangeNotifier{
  CollectionReference wordCards =
      FirebaseFirestore.instance.collection('wordCards');

  String? cardWord, word, meaning;
  int? cardNum;
  var firebaseStorage;
  int cardType = 0;
  int cardIndex = 0;

  WordCardInformation(){
    setInformation();
  }

  void changeCardType(){
    cardType = cardType == 0 ? 1 : 0;
    cardWord = cardType == 0 ? word : meaning;
    notifyListeners();
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

  String getCardType() => cardType == 0 ? "meaning" : "word";

  String getInformation() {
    if(firebaseStorage != null){
      if (cardType == 0) {
        cardWord = firebaseStorage.docs[cardIndex]['word'];
      } else {
        cardWord = firebaseStorage.docs[cardIndex]['meaning'];
      }
    }
    return cardWord ??"loading";
  }
}