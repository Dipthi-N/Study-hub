import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _groupName;
  String? _groupDescription;
  String? _selectedLocation;
  String _type = 'Group'; // Default to Group
  int? _maxMembers; // Max members input
  List<String> _organizers = [];
  TextEditingController _organizerController = TextEditingController();
  TextEditingController _maxMembersController = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _sessionDate;

  Map<String, Map<String, dynamic>> _locationDetails = {
    'Library Room 1': {'capacity': 50, 'timings': '9:00 AM - 5:00 PM'},
    'Library Room 2': {'capacity': 30, 'timings': '10:00 AM - 4:00 PM'},
    'Café Area': {'capacity': 20, 'timings': '8:00 AM - 8:00 PM'},
    'Lecture Hall A': {'capacity': 100, 'timings': '9:00 AM - 6:00 PM'},
    'Open Park Area': {'capacity': 200, 'timings': '6:00 AM - 10:00 PM'},
  };

  String generateInviteCode() {
    var rand = Random();
    return (rand.nextInt(9000) + 1000).toString();
  }

  Future<void> _pickDate({bool isStartDate = true}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Future<void> _pickSessionDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _sessionDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  void _addOrganizer() {
    if (_organizerController.text.isNotEmpty) {
      setState(() {
        _organizers.add(_organizerController.text);
        _organizerController.clear();
      });
    }
  }

  bool _validateInputs() {
    if (_groupName == null || _groupName!.isEmpty) return false;
    if (_selectedLocation == null) return false;
    if (_maxMembers == null || _maxMembers! <= 0) return false;

    if (_type == 'Group') {
      if (_startDate == null || _endDate == null) return false;
      if (_endDate!.isBefore(_startDate!)) return false;
    } else {
      if (_sessionDate == null || _startTime == null || _endTime == null) {
        return false;
      }
      if (_endTime!.hour < _startTime!.hour ||
          (_endTime!.hour == _startTime!.hour &&
              _endTime!.minute <= _startTime!.minute)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _saveData() async {
    if (_validateInputs()) {
      User? user = _auth.currentUser;
      if (user != null) {
        try {
          String inviteCode = generateInviteCode();

          Map<String, dynamic> data = {
            'name': _groupName,
            'description': _groupDescription,
            'type': _type,
            'location': _selectedLocation,
            'capacity': _locationDetails[_selectedLocation]!['capacity'],
            'timings': _locationDetails[_selectedLocation]!['timings'],
            'max_members': _maxMembers,
            'created_by': user.email,
            'creator_name': user.displayName ?? 'Unknown',
            'organizers': _organizers,
            'invite_code': inviteCode,
            'creator_id': user.uid,
            'created_at': FieldValue.serverTimestamp(),
          };

          if (_type == 'Group') {
            data['start_date'] = _startDate!.toIso8601String();
            data['end_date'] = _endDate!.toIso8601String();
            await _firestore.collection('groups').add(data);
          } else {
            data['session_date'] = _sessionDate!.toIso8601String();
            data['start_time'] = _startTime!.format(context);
            data['end_time'] = _endTime!.format(context);
            await _firestore.collection('sessions').add(data);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    '$_type created successfully! Invite code: $inviteCode')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating $_type: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields correctly.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create $_type')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _type,
              items: ['Group', 'Session']
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Type'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Group Name'),
              onChanged: (value) {
                _groupName = value;
              },
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                _groupDescription = value;
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              items: _locationDetails.keys
                  .map((location) =>
                      DropdownMenuItem(value: location, child: Text(location)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
              decoration: InputDecoration(labelText: 'Location'),
            ),
            if (_selectedLocation != null) ...[
              SizedBox(height: 10),
              Text(
                'Capacity: ${_locationDetails[_selectedLocation!]!['capacity']}',
              ),
              Text(
                'Timings: ${_locationDetails[_selectedLocation!]!['timings']}',
              ),
            ],
            SizedBox(height: 10),
            TextField(
              controller: _maxMembersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Max Members'),
              onChanged: (value) {
                _maxMembers = int.tryParse(value);
              },
            ),
            if (_type == 'Group') ...[
              ElevatedButton(
                onPressed: () => _pickDate(isStartDate: true),
                child: Text(_startDate == null
                    ? 'Select Start Date'
                    : 'Start: ${_startDate!.toLocal().toString().split(' ')[0]}'),
              ),
              ElevatedButton(
                onPressed: () => _pickDate(isStartDate: false),
                child: Text(_endDate == null
                    ? 'Select End Date'
                    : 'End: ${_endDate!.toLocal().toString().split(' ')[0]}'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: _pickSessionDate,
                child: Text(_sessionDate == null
                    ? 'Select Session Date'
                    : 'Session: ${_sessionDate!.toLocal().toString().split(' ')[0]}'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickTime(true),
                    child: Text(_startTime == null
                        ? 'Select Start Time'
                        : 'Start: ${_startTime!.format(context)}'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _pickTime(false),
                    child: Text(_endTime == null
                        ? 'Select End Time'
                        : 'End: ${_endTime!.format(context)}'),
                  ),
                ],
              ),
            ],
            SizedBox(height: 10),
            TextField(
              controller: _organizerController,
              decoration: InputDecoration(labelText: 'Add Organizer'),
            ),
            ElevatedButton(
              onPressed: _addOrganizer,
              child: Text('Add Organizer'),
            ),
            Wrap(
              spacing: 10,
              children: _organizers
                  .map((organizer) => Chip(label: Text(organizer)))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Create $_type'),
            ),
          ],
        ),
      ),
    );
  }
}
