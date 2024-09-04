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
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _users = [];
  List<DocumentSnapshot> _filteredUsers = []; // For filtered user results
  Set<String> _addedUserIds = {};
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_filterUsers); // Listen to search query changes
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;

        DocumentSnapshot contactsSnapshot = await _firestore.collection('contacts').doc(userId).get();
        Map<String, dynamic>? contactsData = contactsSnapshot.data() as Map<String, dynamic>?;
        if (contactsData != null) {
          setState(() {
            _addedUserIds = contactsData.keys.toSet();
          });
        }

        QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
        setState(() {
          _users = usersSnapshot.docs
              .where((doc) => doc.id != userId && !_addedUserIds.contains(doc.id))
              .toList();
          _filteredUsers = _users; // Initialize filtered list
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

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        String username = (user['username'] ?? 'Unknown').toLowerCase();
        return username.contains(query);
      }).toList();
    });
  }

  Future<void> _addContact(String otherUserId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;

        DocumentReference newChannelRef = _firestore.collection('messages').doc();
        String channelId = newChannelRef.id;

        await _firestore.collection('contacts').doc(userId).set(
          {otherUserId: channelId},
          SetOptions(merge: true),
        );

        await _firestore.collection('contacts').doc(otherUserId).set(
          {userId: channelId},
          SetOptions(merge: true),
        );

        await newChannelRef.set({
          'participants': [userId, otherUserId],
          'created_at': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added to contacts')),
        );

        setState(() {
          _addedUserIds.add(otherUserId);
          _users.removeWhere((user) => user.id == otherUserId);
          _filteredUsers = _users; // Update the filtered list
        });

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
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Users',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: _filteredUsers.isEmpty
                  ? const Center(child: Text('No users available'))
                  : ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  var user = _filteredUsers[index];
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
          ],
        ),
      ),
    );
  }
}
