import 'package:flutter/material.dart';
import 'create_group.dart'; // Import CreateGroupPage
import 'join_group.dart'; // Import JoinGroupPage

class StudyGroupPage extends StatelessWidget {
  const StudyGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Groups'),
        backgroundColor: const Color.fromARGB(255, 188, 116, 239),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create or Join a Study Group',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            // Button to navigate to Create Group page
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateGroupPage(), // Removed const
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 188, 116, 239),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Create Group'),
            ),
            const SizedBox(height: 16),
            // Button to navigate to Join Group page
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => JoinGroupPage(), // Removed const
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 188, 116, 239),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Join Group'),
            ),
          ],
        ),
      ),
    );
  }
}