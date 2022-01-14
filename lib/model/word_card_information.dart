import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WordCardInformation extends ChangeNotifier{
  CollectionReference wordCards =
      FirebaseFirestore.instance.collection('wordCards');
  FirebaseAuth auth = FirebaseAuth.instance;

  String? cardWord;
  int? cardNum;
  String? userId;
  var firebaseStorage;
  int cardIndex = 0;
  Color starColor = Colors.grey;

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
    var currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser.toString();
    notifyListeners();
  }

  String getCardType(String cardType) => cardType == "word" ? "meaning" : "word";

  void setStarColor()async{
    if(userId != null){
      if(firebaseStorage.docs[cardIndex]['word'].contains(userId)){
        starColor = Colors.yellow;
      }
    }else{
      starColor = Colors.grey;
    }
    await wordCards.add({
      "users id":userId
    });
  }
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