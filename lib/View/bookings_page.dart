import 'package:flutter/material.dart';

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          BookingItem(
            title: 'Hotel Booking',
            date: 'June 20, 2024',
            location: 'Hotel California',
          ),
          BookingItem(
            title: 'Restaurant Reservation',
            date: 'June 22, 2024',
            location: 'The Great Restaurant',
          ),
          BookingItem(
            title: 'Event Ticket',
            date: 'June 25, 2024',
            location: 'City Hall',
          ),
        ],
      ),
    );
  }
}

class BookingItem extends StatelessWidget {
  final String title;
  final String date;
  final String location;

  BookingItem(
      {required this.title, required this.date, required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            SizedBox(height: 4),
            Text(location),
          ],
        ),
      ),
    );
  }
}
