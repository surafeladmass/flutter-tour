
class Hotel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isFavorite;
  final List<String> facilities;
  final double rating;
  final String address;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isFavorite,
    required this.facilities,
    required this.rating,
    required this.address,
  });

  factory Hotel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>?; // Safely cast to Map<String, dynamic>
    if (data == null) {
      // Handle the case where the document does not exist
      throw Exception('Hotel document not found');
    }
    return Hotel(
      id: doc.id,
      name: data['name'] ?? 'Unknown', // Provide a default value
      description: data['description'] ?? 'No description available', // Provide a default value
      imageUrl: data['imageUrl'] ?? '', // Provide a default value
      isFavorite: data['isFavorite'] ?? false,
      facilities: List<String>.from(data['facilities'] ?? []),
      rating: data['rating']?.toDouble() ?? 0.0, // Ensure rating is a double and provide default value
      address: data['address'] ?? 'No address available', // Provide a default value
    );
  }
}
