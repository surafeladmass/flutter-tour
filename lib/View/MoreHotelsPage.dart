import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/hotel_provider.dart';

class MoreHotelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hotelProvider = Provider.of<HotelProvider>(context);
    final hotels = hotelProvider.hotels;

    return Scaffold(
      appBar: AppBar(
        title: Text('More Hotels & Restaurants'),
      ),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.network(
                    hotel.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          hotel.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      hotel.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: hotel.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      hotelProvider.toggleFavorite(hotel);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
