import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Fetch the logged-in user's email
    String? loggedInEmail = _auth.currentUser?.email;

    // Hardcoded user data
    Map<String, dynamic> usersData = {
      'dipthi.2022@vitstudent.ac.in': {
        'username': 'DIPTHI',
        'email': 'dipthi.2022@vitstudent.ac.in',
        'createdGroups': ['Ideathon'],
        'members': ['kavishree.g2022@vitstudent.ac.in', 'sakarisha.t2022@vitstudent.ac.in'],
        'feedbackStars': 3,
      },
      'kavishree.g2022@vitstudent.ac.in': {
        'username': 'Kavishree',
        'email': 'kavishree.g2022@vitstudent.ac.in',
        'joinedGroups': ['Ideathon'],
      },
    };

    // Get user details based on logged-in email
    var userData = usersData[loggedInEmail] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 170, 79, 186),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userData.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/img2.png'), // Add your image asset here
                  ),
                  SizedBox(height: 20),

                  // Username and email
                  Text(
                    'Username: ${userData['username']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: ${userData['email']}',
                    style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 101, 3, 98)),
                  ),
                  SizedBox(height: 20),

                  // Created Groups (for Dipthi)
                  if (userData['createdGroups'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Created Groups:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        for (var group in userData['createdGroups'])
                          Text(
                            group,
                            style: TextStyle(fontSize: 16),
                          ),
                        SizedBox(height: 20),

                        // Members of the group
                        if (userData['members'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Members:',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              for (var member in userData['members'])
                                Text(
                                  member,
                                  style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 125, 35, 131)),
                                ),
                            ],
                          ),
                      ],
                    ),

                  // Joined Groups (for Kavishree)
                  if (userData['joinedGroups'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Joined Groups:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        for (var group in userData['joinedGroups'])
                          Text(
                            group,
                            style: TextStyle(fontSize: 16),
                          ),
                      ],
                    ),

                  SizedBox(height: 20),

                  // Feedback stars
                  if (userData['feedbackStars'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feedback:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            userData['feedbackStars'],
                            (index) => Icon(Icons.star, color: Colors.amber),
                          ),
                        ),
                      ],
                    ),
                ],
              )
            : Center(
                child: Text(
                  'No profile data found.',
                  style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 107, 29, 100)),
                ),
              ),
      ),
    );
  }
}
