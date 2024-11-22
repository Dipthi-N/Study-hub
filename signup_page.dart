import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@(vitstudent\.ac\.in|vit\.ac\.in)$');

  Future<void> signup() async {
    String username = _usernameController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (!emailRegex.hasMatch(email)) {
      setState(() {
        errorMessage = 'Please use a valid VIT email address.';
      });
      return;
    }

    try {
      // Check if the username already exists
      final usernameQuery =
          await _firestore.collection('users').doc(username).get();

      if (usernameQuery.exists) {
        setState(() {
          errorMessage = 'Username already taken. Please choose another.';
        });
        return;
      }

      // Create the user in Firebase Authentication
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore under the username
      await _firestore.collection('users').doc(username).set({
        'username': username,
        'email': email,
        'phone': phone,
        'created_groups': [],
        'joined_groups': [],
      });

      // Navigate to the HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/image.png'), // Replace with your image path
                fit: BoxFit.cover, // Make the image cover the entire screen
              ),
            ),
          ),

          // Signup form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Username text field with rounded corners
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor:
                            Colors.white, // Semi-transparent field background
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Curved corners
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Phone number text field with rounded corners
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        filled: true,
                        fillColor:
                            Colors.white, // Semi-transparent field background
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Curved corners
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),

                    // Email text field with rounded corners
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Password text field with rounded corners
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Curved corners
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),

                    // Signup button
                    ElevatedButton(
                      onPressed: signup,
                      child: Text('Signup'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15), // Button padding
                      ),
                    ),
                    SizedBox(
                        height:
                            20), // Gap between signup button and error message

                    // Display error message if any
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}