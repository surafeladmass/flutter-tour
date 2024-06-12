import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/hotel_provider.dart';
import 'hotel_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourism/View/hotel_detail.dart';

class HotelsAndRestaurantsPage extends StatefulWidget {
  @override
  _HotelsAndRestaurantsPageState createState() =>
      _HotelsAndRestaurantsPageState();
}

class _HotelsAndRestaurantsPageState extends State<HotelsAndRestaurantsPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels & Restaurants'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Hotels & Restaurants...',
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
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('hotels').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No hotels found.'));
                }

                var hotels = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  var name = data['name'] as String;
                  return name.toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: hotels.length > 3 ? 4 : hotels.length,
                  itemBuilder: (context, index) {
                    if (index == 3) {
                      return Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelDetailPage(),
                              ),
                            );
                          },
                          child: Text('Discover More'),
                        ),
                      );
                    }
                    var doc = hotels[index];
                    var hotel = Hotel.fromFirestore(doc);

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          hotel.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          hotel.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          hotel.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            hotel.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: hotel.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            // Implement favorite toggle functionality
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HotelDetailPage(hotel: hotel),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
