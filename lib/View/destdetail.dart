// screens/destination_detail_page.dart
import 'package:flutter/material.dart';
import 'package:tourism/Model/destination.dart';

class DestinationDetailPage extends StatelessWidget {
  final Destination destination;

  DestinationDetailPage({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (destination.imageUrl.isNotEmpty)
              Image.network(
                destination.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            Text(
              destination.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(destination.description),
            // Add more details here as needed
          ],
        ),
      ),
    );
  }
}
