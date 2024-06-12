import 'package:flutter/material.dart';

import 'package:tourism/Model/come.dart';

class CityDetailPage extends StatelessWidget {
  final City city;

  const CityDetailPage({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(city.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              background: Image.network(
                city.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    city.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Discover More",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Image.network(
                            "https://images.unsplash.com/photo-1595425189225-11c404d4853a",
                            width: 160,
                            fit: BoxFit.cover),
                        SizedBox(width: 8),
                        Image.network(
                            "https://images.unsplash.com/photo-1581069926300-ace6656b85d8",
                            width: 160,
                            fit: BoxFit.cover),
                        SizedBox(width: 8),
                        Image.network(
                            "https://images.unsplash.com/photo-1599331052326-4baf38d05a1b",
                            width: 160,
                            fit: BoxFit.cover),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Travel Guideline",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Here are some travel guidelines and important information about the destination.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.hotel, size: 30),
                          SizedBox(height: 4),
                          Text("Accommodation"),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.directions, size: 30),
                          SizedBox(height: 4),
                          Text("Administration"),
                        ],
                      ),
                      const Column(
                        children: [
                          Icon(Icons.local_activity, size: 30),
                          SizedBox(height: 4),
                          Text("Activities"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
