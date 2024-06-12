import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/city.dart';

class CityProvider with ChangeNotifier {
  List<City> _cities = [];

  List<City> get cities => _cities;

  CityProvider() {
    fetchCities();
  }

  Future<void> fetchCities() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('cities').get();
    _cities = querySnapshot.docs.map((doc) => City.fromFirestore(doc)).toList();
    notifyListeners();
  }

  void toggleFavorite(City city) {
    city.isFavorite = !city.isFavorite;
    notifyListeners();
  }
}
