import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a City model
class City {
  final String name;
  final String description;
  final String imageUrl;

  City({required this.name, required this.description, required this.imageUrl});

  // Factory constructor to create a City from Firestore data
  factory City.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return City(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

class TouristDestinationPage extends StatefulWidget {
  @override
  _TouristDestinationPageState createState() => _TouristDestinationPageState();
}

class _TouristDestinationPageState extends State<TouristDestinationPage> {
  List<City> cities = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    _fetchCities();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _fetchMoreCities();
      }
    });
  }

  Future<void> _fetchCities() async {
    setState(() => isLoading = true);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('tourist_destinations')
        .limit(10)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      setState(() {
        cities =
            querySnapshot.docs.map((doc) => City.fromFirestore(doc)).toList();
      });
    } else {
      setState(() => hasMore = false);
    }

    setState(() => isLoading = false);
  }

  Future<void> _fetchMoreCities() async {
    if (!hasMore) return;
    setState(() => isLoading = true);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('tourist_destinations')
        .startAfterDocument(lastDocument!)
        .limit(10)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      setState(() {
        cities.addAll(
            querySnapshot.docs.map((doc) => City.fromFirestore(doc)).toList());
      });
    } else {
      setState(() => hasMore = false);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Tourist Destinations'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: isLoading && cities.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: cities.length + 1,
              itemBuilder: (context, index) {
                if (index == cities.length) {
                  return hasMore
                      ? Center(child: CircularProgressIndicator())
                      : Container();
                }
                final city = cities[index];
                return ListTile(
                  leading: Image.network(
                    city.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(city.name),
                  subtitle: Text(city.description),
                  trailing: Icon(Icons.favorite_border),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityDetailPage(city: city),
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'My Account'),
        ],
      ),
    );
  }
}

// Placeholder for the CityDetailPage
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
