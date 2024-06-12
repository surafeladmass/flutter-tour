// providers/destination_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourism/Model/destination.dart';

class DestinationProvider with ChangeNotifier {
  List<Destination> _destinations = [];

  List<Destination> get destinations => _destinations;

  DestinationProvider() {
    fetchDestinations();
  }

  Future<void> fetchDestinations() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('cultural_festivals').get();
    _destinations = querySnapshot.docs
        .map((doc) => Destination.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    notifyListeners();
  }
}
