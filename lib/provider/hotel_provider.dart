import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism/Model/hotel.dart';

class HotelProvider with ChangeNotifier {
  List<Hotel> _hotels = [];

  List<Hotel> get hotels => _hotels;

  HotelProvider() {
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    FirebaseFirestore.instance
        .collection('hotels')
        .snapshots()
        .listen((snapshot) {
      _hotels = snapshot.docs.map((doc) => Hotel.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }

  void toggleFavorite(Hotel hotel) {
    hotel.isFavorite = !hotel.isFavorite;
    notifyListeners();
  }
}
