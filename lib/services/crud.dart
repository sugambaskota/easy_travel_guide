import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class MethodsCollec {
  Future getData() async {
    return Firestore.instance.collection('testcrud').snapshots();
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) async {
    var rawSuggestion = suggestion.split(' ');
    for (int i = 0; i < rawSuggestion.length; i++) {
      String temp = rawSuggestion[i].toLowerCase();
      rawSuggestion[i] = temp[0].toUpperCase() + temp.substring(1);
    }
    String parsedSuggestion = rawSuggestion.join(' ');
    var snap = await Firestore.instance
        .collection('testcrud')
        .where('title', isEqualTo: parsedSuggestion)
        .getDocuments();
    return snap.documents;
  }
}
