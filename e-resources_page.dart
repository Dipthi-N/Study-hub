import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class EResources extends StatefulWidget {
  const EResources({super.key});

  @override
  _EResourcesState createState() => _EResourcesState();
}

class _EResourcesState extends State<EResources> {
  String notes = ''; // Variable to store current notes
  List<String> savedNotes = []; // List to store saved notes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Make the entire body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                  height: 50.0), // Adds space between the top and the cards
              GridView.count(
                shrinkWrap: true, // Prevents GridView from expanding infinitely
                physics:
                    const NeverScrollableScrollPhysics(), // Disables GridView scrolling
                crossAxisCount: 2, // 2 cards per row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  buildCard('E-Gateway', Icons.description,
                      'https://egateway.vit.ac.in/home'),
                  buildCard('E-Books', Icons.book,
                      'http://site.ebrary.com/lib/vit/home.action'),
                  buildCard('Research Papers', Icons.science,
                      'https://vit.researgence.com/'),
                  buildCard('Publications', Icons.library_books,
                      'https://vit.ac.in/school/research-publications/score/publications'),
                ],
              ),
              const SizedBox(
                  height: 20.0), // Space between cards and notes section
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Add Notes',
                  border: OutlineInputBorder(),
                  hintText: 'Type your notes here...',
                ),
                maxLines: 3, // Allow multiple lines
                onChanged: (value) {
                  setState(() {
                    notes = value; // Update notes variable on text change
                  });
                },
              ),
              const SizedBox(
                  height: 10.0), // Space between TextField and button
              ElevatedButton(
                onPressed: () {
                  _saveNotes();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 158, 67, 172), // Purple button color
                ),
                child: const Text('Save Notes'),
              ),
              const SizedBox(height: 20.0), // Space before the saved notes
              const Text(
                'Saved Notes:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0), // Space before the notes list
              // Displaying saved notes in a ListView
              ListView.builder(
                shrinkWrap: true, // Prevents ListView from expanding infinitely
                physics:
                    const NeverScrollableScrollPhysics(), // Disables ListView scrolling
                itemCount: savedNotes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(savedNotes[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String title, IconData icon, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 158, 67, 172), // Purple background color
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  void _saveNotes() {
    if (notes.isNotEmpty) {
      setState(() {
        savedNotes.add(notes); // Add the current notes to the saved notes list
        notes = ''; // Clear the notes after saving
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notes saved!')),
      );
    }
  }
}