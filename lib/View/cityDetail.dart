import 'package:flutter/material.dart';
import '../Model/city.dart';

class CityDetailPage extends StatelessWidget {
  final City city;

  CityDetailPage({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(city.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(city.imageUrl),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              city.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(city.description),
          ),
        ],
      ),
    );
  }
}
