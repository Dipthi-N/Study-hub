import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart'; // Import ChatPage here

class JoinGroupPage extends StatefulWidget {
  @override
  _JoinGroupPageState createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _inviteCodeController = TextEditingController();
  String? _userEmail;
  String _selectedType = 'Group'; // Default type

  @override
  void initState() {
    super.initState();
    _userEmail = _auth.currentUser?.email;
  }

  Future<void> _joinEntity(
      String entityId, String inviteCode, bool isGroup) async {
    try {
      final collection = isGroup ? 'groups' : 'sessions';
      DocumentSnapshot entityDoc =
          await _firestore.collection(collection).doc(entityId).get();

      if (entityDoc.exists) {
        String entityInviteCode = entityDoc['invite_code'];

        // Check if invite code matches
        if (inviteCode == entityInviteCode) {
          // Update the group or session with the user email
          await _firestore.collection(collection).doc(entityId).update({
            'members': FieldValue.arrayUnion([_userEmail]),
          });

          // Success message after update
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'You have successfully joined the ${_selectedType.toLowerCase()}!'),
            ),
          );

          // Navigate to the ChatPage after joining the group
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                groupId: entityId,
                groupName: entityDoc['name'],
              ),
            ),
          );
        } else {
          // Invalid invite code
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid invite code!')),
          );
        }
      }
    } catch (e) {
      // Error handling
      print('Error joining entity: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error joining the $_selectedType. Please try again later.'),
        ),
      );
    }
  }

  Future<void> _getInviteCode(String entityId, bool isGroup) async {
    try {
      final collection = isGroup ? 'groups' : 'sessions';
      DocumentSnapshot entityDoc =
          await _firestore.collection(collection).doc(entityId).get();

      if (entityDoc.exists) {
        String inviteCode = entityDoc['invite_code'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invite Code: $inviteCode')),
        );
      }
    } catch (e) {
      print('Error retrieving invite code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving the invite code.')),
      );
    }
  }

  void _showInviteCodeDialog(String entityId, bool isGroup) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Invite Code'),
          content: TextField(
            controller: _inviteCodeController,
            decoration: InputDecoration(hintText: 'Invite Code'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String inviteCode = _inviteCodeController.text.trim();
                if (inviteCode.isNotEmpty) {
                  _joinEntity(entityId, inviteCode, isGroup);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter an invite code')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Join'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDetailsDialog(QueryDocumentSnapshot entity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Details of ${entity['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location: ${entity['location']}'),
              Text('Timings: ${entity['timings']}'),
              Text('Created By: ${entity['creator_name']}'),
              if (_selectedType == 'Group')
                Text(
                    'Start Date: ${entity['start_date']}\nEnd Date: ${entity['end_date']}'),
              if (_selectedType == 'Session')
                Text('Session Date: ${entity['session_date']}'),
              Text('Organizers: ${entity['organizers'].join(', ')}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                _getInviteCode(entity.id, _selectedType == 'Group');
                Navigator.of(context).pop();
              },
              child: Text('Get Invite Code'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join a $_selectedType'),
        actions: [
          DropdownButton<String>(
            value: _selectedType,
            items: ['Group', 'Session']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection(_selectedType.toLowerCase() + 's')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var entities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) {
              var entity = entities[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Description: ${entity['description']}'),
                      Text('Location: ${entity['location']}'),
                      Text('Type: ${_selectedType}'),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _showDetailsDialog(entity);
                            },
                            child: Text('Show Details'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              _showInviteCodeDialog(
                                  entity.id, _selectedType == 'Group');
                            },
                            child: Text('Join $_selectedType'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
