import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  final String name;
  final String description;
  final String imageUrl;
  bool isFavorite;

  City({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Factory constructor to create a City from Firestore data
  factory City.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return City(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
