import 'package:flutter/material.dart';

// screens/culture_and_spiritual_page.dart

import 'package:provider/provider.dart';

import 'package:tourism/provider/destinationsProvider.dart';
import 'package:tourism/View/destdetail.dart';

class CultureAndSpiritualPage extends StatefulWidget {
  @override
  _CultureAndSpiritualPageState createState() =>
      _CultureAndSpiritualPageState();
}

class _CultureAndSpiritualPageState extends State<CultureAndSpiritualPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final destinationProvider = Provider.of<DestinationProvider>(context);
    final destinations = destinationProvider.destinations.where((destination) {
      return destination.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cultural and Spiritual Ethiopia'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search destination...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(
                      destination.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(destination.description),
                    leading: destination.imageUrl.isNotEmpty
                        ? Image.network(
                            destination.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DestinationDetailPage(destination: destination),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
