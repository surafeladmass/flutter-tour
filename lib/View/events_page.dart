import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          EventItem(
            title: 'Music Festival',
            date: 'June 10, 2024',
            description: 'Join us for a day of music and fun.',
            location: 'Friendship park',
          ),
          EventItem(
            title: 'Art Exhibition',
            date: 'June 12, 2024',
            description: 'Explore the latest art from local artists.',
            location: 'Mellineium Hall',
          ),
          EventItem(
            title: 'Great ethiopian Run',
            date: 'July 25, 2024',
            description: 'Taste dishes from around the world.',
            location: 'Addis Ababa',
          ),
          EventItem(
            title: 'Ethiopian Nathional day',
            date: 'augest 8, 2024',
            description: 'Taste dishes from around the world.',
            location: 'Downtown Square',
          ),
          EventItem(
            title: 'Adwa Victory day',
            date: 'June 15, 2024',
            description: 'Taste dishes from around the world.',
            location: 'Adwa Squere',
          ),
        ],
      ),
    );
  }
}

class EventItem extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String location;

  EventItem(
      {required this.title,
      required this.date,
      required this.description,
      required this.location});

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
            Text(description),
            SizedBox(height: 4),
            Text(location),
          ],
        ),
      ),
    );
  }
}
