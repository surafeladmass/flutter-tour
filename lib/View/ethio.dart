import 'package:flutter/material.dart';

class EthioPage extends StatefulWidget {
  const EthioPage({super.key});

  @override
  State<EthioPage> createState() => _EthioPageState();
}

class _EthioPageState extends State<EthioPage> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ethiopia'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: myWidth * 0.05, vertical: myHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image
              Container(
                height: myHeight * 0.3,
                width: myWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/ethiopia.jpg'), // Add a relevant image in the assets
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: myHeight * 0.03),

              // General Information
              Text(
                'General Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: myHeight * 0.01),
              Text(
                'Ethiopia, in the Horn of Africa, is a rugged, landlocked country split by the Great Rift Valley. With archaeological finds dating back more than 3 million years, it’s a place of ancient culture. Among its important sites are Lalibela with its rock-cut Christian churches from the 12th–13th centuries and Aksum, the ruins of an ancient city with obelisks, tombs, castles, and Our Lady Mary of Zion church.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: myHeight * 0.03),

              // Geography
              Text(
                'Geography',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: myHeight * 0.01),
              Text(
                'Ethiopia is located in the Horn of Africa and is bordered by Eritrea to the north, Djibouti and Somalia to the east, Kenya to the south, and Sudan and South Sudan to the west. It is a country of high plateaus, deep valleys, and some of the highest mountains in Africa.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: myHeight * 0.03),

              // Culture
              Text(
                'Culture',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: myHeight * 0.01),
              Text(
                'Ethiopia has a rich cultural heritage that includes music, dance, and cuisine. It is known for its traditional coffee ceremonies, religious festivals, and the unique script and calendar.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: myHeight * 0.03),

              // Additional Sections
              Text(
                'Economy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: myHeight * 0.01),
              Text(
                'Ethiopia has one of the fastest-growing economies in the world, driven by agriculture, manufacturing, and services. Coffee is a major export product.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: myHeight * 0.03),

              Text(
                'Tourism',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: myHeight * 0.01),
              Text(
                'Tourism in Ethiopia is on the rise with attractions such as the Simien Mountains, the rock-hewn churches of Lalibela, the castles of Gondar, and the historical city of Axum.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: myHeight * 0.03),

              Text(
                'Languages',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: myHeight * 0.01),
              Text(
                'Ethiopia is a multilingual nation with around 80 different languages spoken. The official language is Amharic, but Oromiffa and Tigrigna are also widely spoken.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: myHeight * 0.03),

              Text(
                'Cuisine',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: myHeight * 0.01),
              Text(
                'Ethiopian cuisine is known for its unique flavors and communal eating style. Dishes such as injera (a type of sourdough flatbread), doro wat (spicy chicken stew), and various lentil dishes are staples.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
