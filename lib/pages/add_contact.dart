import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List<DocumentSnapshot> _users = [];
  Set<String> _addedUserIds = {};  // Track IDs of already added users
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;

        // Fetch the user's contacts
        DocumentSnapshot contactsSnapshot = await _firestore.collection('contacts').doc(userId).get();
        Map<String, dynamic>? contactsData = contactsSnapshot.data() as Map<String, dynamic>?;
        if (contactsData != null) {
          setState(() {
            _addedUserIds = contactsData.keys.toSet();
          });
        }

        // Fetch all users
        QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
        setState(() {
          _users = usersSnapshot.docs
              .where((doc) => doc.id != userId && !_addedUserIds.contains(doc.id))  // Filter out already added users
              .toList();
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } catch (e) {
      print("Error fetching users: $e");
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _addContact(String otherUserId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;

        // Create a new document in the messages collection to generate a unique channel ID
        DocumentReference newChannelRef = _firestore.collection('messages').doc();
        String channelId = newChannelRef.id;

        // Add to contacts collection for both users
        await _firestore.collection('contacts').doc(userId).set(
          {otherUserId: channelId},
          SetOptions(merge: true),
        );

        await _firestore.collection('contacts').doc(otherUserId).set(
          {userId: channelId},
          SetOptions(merge: true),
        );

        // Create an entry in the messages collection for the new channel
        await newChannelRef.set({
          'participants': [userId, otherUserId],
          'created_at': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added to contacts')),
        );

        // Update the list of added users and refresh the list
        setState(() {
          _addedUserIds.add(otherUserId);
          _users.removeWhere((user) => user.id == otherUserId);
        });

        // Optionally, navigate back to the contact list
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error adding contact: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contacts'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.blueAccent[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent[100]!, Colors.yellow[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error
            ? const Center(child: Text('Error fetching users'))
            : _users.isEmpty
            ? const Center(child: Text('No users available'))
            : ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            var user = _users[index];
            String username = user['username'] ?? 'Unknown';
            String userId = user.id;

            return ListTile(
              title: Text(username),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addContact(userId),
              ),
            );
          },
        ),
      ),
    );
  }
}
