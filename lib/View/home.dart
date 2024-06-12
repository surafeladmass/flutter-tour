import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'events_page.dart';
import 'bookings_page.dart';
import 'package:share/share.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  int _selectedIndex = 0;
  String username = '';
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Define the scaffold key

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    username = user?.displayName ?? 'Guest';
  }

  static List<Widget> _pages = <Widget>[
    HomeContent(),
    EventsPage(),
    BookingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF2F2F2),
      appBar: AppBar(
        title: Text('Visit Ethiopia'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(user?.email ?? 'No Email'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('My Account'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAccountPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SharePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpSupportPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.policy),
            title: Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Terms & Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsConditionsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user?.displayName ?? 'Guest';

    List<Map<String, String>> destinations = [
      {
        'title': 'Meskel Festival, Addis Ababa',
        'imagePath': 'assets/hotels/culture.jpg'
      },
      {
        'title': 'Sofumer Cave, Bale',
        'imagePath': 'assets/hotels/destination.jpg'
      },
      {
        'title': 'Bishoftu, Bishoftu',
        'imagePath': 'assets/hotels/destination.jpg'
      },
      {
        'title': 'Sky Light, Addis Ababa',
        'imagePath': 'assets/hotels/destination.jpg'
      },
    ];

    List<Map<String, String>> filteredDestinations = destinations
        .where((destination) => destination['title']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: myWidth * 0.02, vertical: myHeight * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: myWidth * 0.06,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  SizedBox(width: myWidth * 0.02),
                  RichText(
                    text: TextSpan(
                      text: 'Hello, ',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(
                          text: username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.notifications_none),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: myHeight * 0.04),

          // Title Section
          Text(
            'Explore new destinations',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: myHeight * 0.02),

          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: myWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search your destination',
                icon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          SizedBox(height: myHeight * 0.03),

          // Category
          //
          //
          //
          //
          //

          // Category Section
          Text(
            'Category',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: myHeight * 0.01),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                categoryItem(context, 'About Ethiopia',
                    'assets/hotels/hotel.png', '/ethiopia'),
                categoryItem(context, 'Hotels & Restuarants',
                    'assets/hotels/hotel.png', '/hotels_resturants'),
                categoryItem(context, 'Cultural & Spiritual',
                    'assets/hotels/culture.jpg', '/cultural_festivals'),
                categoryItem(context, 'Destinations',
                    'assets/hotels/destination.jpg', '/tourist_destination'),
                categoryItem(
                    context, 'Cities', 'assets/hotels/cities.jpg', '/cities'),
              ],
            ),
          ),
          SizedBox(height: myHeight * 0.03),

          // Recommended Section
          Text(
            'Recommended',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: myHeight * 0.01),
          Container(
            height: myHeight * 0.3, // Adjust the height as needed
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: filteredDestinations.map((destination) {
                return recommendedItem(
                    context, destination['title']!, destination['imagePath']!);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryItem(
      BuildContext context, String title, String imagePath, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget recommendedItem(BuildContext context, String title, String imagePath) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // Implement navigation to detailed page if needed
      },
      child: Container(
        width: myWidth * 0.6,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                imagePath,
                height: myHeight * 0.2,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            title: Text('Account Settings'),
            onTap: () {
              // Navigate to account settings page
            },
          ),
          ListTile(
            title: Text('Change Password'),
            onTap: () {
              // Navigate to change password page
            },
          ),
          ListTile(
            title: Text('Language'),
            onTap: () {
              // Navigate to language settings page
            },
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
              // Na
              //AboutPage   vigate to about page
            },
          ),
        ],
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {"question": "How to use the app?", "answer": "To use the app, you can..."},
    {
      "question": "How to reset my password?",
      "answer": "To reset your password, go to..."
    },
    // More FAQs...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...faqs.map((faq) {
            return ExpansionTile(
              title: Text(faq["question"]!),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(faq["answer"]!),
                ),
              ],
            );
          }).toList(),
          SizedBox(height: 24),
          Text(
            'Need more help?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to contact support page
            },
            icon: Icon(Icons.contact_mail),
            label: Text('Contact Support'),
          ),
        ],
      ),
    );
  }
}

class SharePage extends StatelessWidget {
  final String appLink = "https://example.com/app";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Share this app with your friends!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Share.share('Check out this amazing app: $appLink');
              },
              icon: Icon(Icons.share),
              label: Text('Share via Social Media'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Share via email
              },
              icon: Icon(Icons.email),
              label: Text('Share via Email'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Share via SMS
              },
              icon: Icon(Icons.message),
              label: Text('Share via SMS'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAccountPage extends StatelessWidget {
  final String userName = "John Doe";
  final String email = "john.doe@example.com";
  final String phoneNumber = "+1234567890";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            SizedBox(height: 16),
            Text(
              'Name: $userName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Phone: $phoneNumber',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile page
              },
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 24),
            Text(
              'Order History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Order #1234'),
                    subtitle: Text('Date: 2024-01-01'),
                    trailing: Text('Status: Delivered'),
                    onTap: () {
                      // View order details
                    },
                  ),
                  ListTile(
                    title: Text('Order #1235'),
                    subtitle: Text('Date: 2024-01-05'),
                    trailing: Text('Status: In Transit'),
                    onTap: () {
                      // View order details
                    },
                  ),
                  // More orders...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  final String privacyPolicy = "Your privacy policy content goes here...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(privacyPolicy),
        ),
      ),
    );
  }
}

class TermsConditionsPage extends StatelessWidget {
  final String termsConditions =
      "Your terms and conditions content goes here...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(termsConditions),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Our Company',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus, velit vel tincidunt luctus, nunc mi fermentum orci, sed convallis ex justo at mauris. Aliquam eget nunc a mauris consectetur volutpat vel nec elit. Duis auctor nec neque sit amet dapibus. Integer at placerat turpis, at semper dui.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('info@example.com'),
              onTap: () {
                // Handle email tapping
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              subtitle: Text('+1 (123) 456-7890'),
              onTap: () {
                // Handle phone tapping
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Address'),
              subtitle: Text('123 Main Street, City, Country'),
              onTap: () {
                // Handle address tapping
              },
            ),
          ],
        ),
      ),
    );
  }
}
