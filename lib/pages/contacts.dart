import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart';
import 'home.dart';

class ContactListScreen extends StatefulWidget {
  final String userId;

  ContactListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Map<String, String> _contacts = {};
  Map<String, String> _latestMessages = {};
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _fetchLatestMessages();
  }

  Future<void> _fetchContacts() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference<Map<String, dynamic>> userRef =
        _firestore.collection('contacts').doc(userId);

        DocumentSnapshot<Map<String, dynamic>> doc = await userRef.get();

        if (doc.exists) {
          Map<String, dynamic>? data = doc.data();
          if (data != null) {
            setState(() {
              _contacts = Map<String, String>.from(data);
              _loading = false;
            });
          } else {
            setState(() {
              _contacts = {};
              _loading = false;
            });
          }
        } else {
          await userRef.set({});
          setState(() {
            _contacts = {};
            _loading = false;
          });
        }
      } else {
        setState(() {
          _loading = true;
        });
      }
    } catch (e) {
      print("Error fetching contacts: $e");
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _fetchLatestMessages() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Fetch latest message for each contact
        for (var contactId in _contacts.values) {
          QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
          await _firestore
              .collection('messages')
              .where('sender', isEqualTo: contactId)
              .where('receiver', isEqualTo: userId)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (messagesSnapshot.docs.isNotEmpty) {
            var message = messagesSnapshot.docs.first.data();
            setState(() {
              _latestMessages[contactId] = message['text'] ?? 'No message';
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching latest messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'Home Page'),
              ),
            );
          },
        ),
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
      body: SizedBox.expand(
        child: Container(
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
              ? const Center(child: Text('Error fetching contacts'))
              : _contacts.isEmpty
              ? const Center(child: Text('No contacts available'))
              : ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              String contactName =
              _contacts.keys.elementAt(index);
              String contactId = _contacts[contactName]!;

              return ListTile(
                leading: const Icon(Icons.account_circle, size: 40),
                title: Text(
                  contactName,
                  textHeightBehavior: const TextHeightBehavior(
                      leadingDistribution: TextLeadingDistribution.even
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  _latestMessages[contactId] ?? 'No messages',
                  overflow: TextOverflow.ellipsis,
                ),
                tileColor: Colors.white24,
                style: ListTileStyle.list,
                minTileHeight: 80,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatterScreen(receiverId: contactId),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
