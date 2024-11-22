import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'study_group.dart';
import 'e-resources_page.dart';
import 'RatePage.dart';
import 'SharePage.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Hub',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF3F1F7),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AboutUsPage(),
    const StudyGroupPage(),
    EResources(),
    RatePage(),
    SharePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Hub'),
        backgroundColor: const Color(0xFF6A1B9A),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _pages[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Study Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore. Learn. Collaborate.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF6A1B9A)),
              title: const Text(
                'My Profile',
                style: TextStyle(color: Color(0xFF6A1B9A)),
              ),
              onTap: () {
                // Navigate to the ProfilePage when clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF6A1B9A)),
              title: const Text(
                'Logout',
                style: TextStyle(color: Color(0xFF6A1B9A)),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Study Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'E-Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Rate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Share',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFAB47BC),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'About Us',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Study Hub is a platform designed to enhance collaboration and learning by offering:',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          _buildFeatureSection(
            context,
            icon: Icons.group,
            title: 'Join Study Groups',
            description: 'Connect with like-minded peers to collaborate on topics of interest.',
          ),
          _buildFeatureSection(
            context,
            icon: Icons.book,
            title: 'Access Resources',
            description: 'Explore a vast collection of curated educational content.',
          ),
          _buildFeatureSection(
            context,
            icon: Icons.rate_review,
            title: 'Rate the App',
            description: 'Provide valuable feedback and help us improve!',
          ),
          _buildFeatureSection(
            context,
            icon: Icons.share,
            title: 'Share with Friends',
            description: 'Spread the word and invite others to collaborate.',
          ),
          const Divider(color: Colors.grey, thickness: 1.0, height: 32),
          const Center(
            child: Text(
              'Our mission is to make learning collaborative and engaging for everyone!',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection(BuildContext context,
      {required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFAB47BC),
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(description),
        ),
      ),
    );
  }
}
