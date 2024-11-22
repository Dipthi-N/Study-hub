import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatePage extends StatefulWidget {
  @override
  _RatePageState createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _groupSessionNameController = TextEditingController();

  int _studyGroupRating = 0; // Rating for Study Group
  int _eResourcesRating = 0; // Rating for E-resources
  int _overallExperienceRating = 0; // Rating for Overall Experience

  // Method to handle rating submission
  Future<void> _submitRating() async {
    final groupSessionName = _groupSessionNameController.text.trim();

    if (groupSessionName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the group/session name.')),
      );
      return;
    }

    try {
      await _firestore.collection('ratings').add({
        'group_session_name': groupSessionName,
        'study_group_rating': _studyGroupRating,
        'e_resources_rating': _eResourcesRating,
        'overall_experience_rating': _overallExperienceRating,
        'submitted_at': DateTime.now(),
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thank You for Rating!', style: TextStyle(fontSize: 16)),
            content: Text(
              'Your ratings have been submitted successfully.\n\n'
              'Group/Session: $groupSessionName\n'
              'Study Groups: $_studyGroupRating\n'
              'E-resources Usage: $_eResourcesRating\n'
              'Overall Study Experience: $_overallExperienceRating',
              style: const TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(fontSize: 16)),
              ),
            ],
          );
        },
      );

      // Reset fields after submission
      _groupSessionNameController.clear();
      setState(() {
        _studyGroupRating = 0;
        _eResourcesRating = 0;
        _overallExperienceRating = 0;
      });
    } catch (e) {
      print('Error submitting ratings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting ratings. Please try again.')),
      );
    }
  }

  // Method to generate the rating stars
  Widget _buildRatingStars(int rating, ValueChanged<int> onRatingChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            onRatingChanged(index + 1); // Set rating when a star is clicked
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Features', style: TextStyle(fontSize: 16)),
        backgroundColor: const Color.fromARGB(255, 188, 116, 239),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Rate the following features:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Input for Group/Session Name
              TextField(
                controller: _groupSessionNameController,
                decoration: const InputDecoration(
                  labelText: 'Group/Session Name',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Study Group Rating
              const Text('Study Group:', style: TextStyle(fontSize: 16)),
              _buildRatingStars(
                _studyGroupRating,
                (rating) => setState(() {
                  _studyGroupRating = rating;
                }),
              ),
              const SizedBox(height: 20),

              // E-resources Rating
              const Text('E-resources Usage:', style: TextStyle(fontSize: 16)),
              _buildRatingStars(
                _eResourcesRating,
                (rating) => setState(() {
                  _eResourcesRating = rating;
                }),
              ),
              const SizedBox(height: 20),

              // Overall Experience Rating
              const Text('Overall Study Experience:', style: TextStyle(fontSize: 16)),
              _buildRatingStars(
                _overallExperienceRating,
                (rating) => setState(() {
                  _overallExperienceRating = rating;
                }),
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _submitRating, // Submit the rating
                child: const Text('Submit Ratings', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 188, 116, 239),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
