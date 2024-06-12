import 'package:flutter/material.dart';
import 'package:tourism/Model/hotel.dart';

class HotelDetailPage extends StatelessWidget {
  final Hotel hotel;

  HotelDetailPage({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              hotel.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              hotel.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(hotel.description),
            SizedBox(height: 16),
            Text(
              'Facilities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: hotel.facilities
                  .map((facility) => Chip(label: Text(facility)))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text('Rating: ${hotel.rating}'),
            Text('Address: ${hotel.address}'),
          ],
        ),
      ),
    );
  }
}
