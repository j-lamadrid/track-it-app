import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart';
import 'home.dart';
import 'add_contact.dart';  // Import the new screen

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Map<String, String> _contacts = {};
  final Map<String, String> _latestMessages = {};
  final Map<String, String> _contactEmails = {};
  bool _loading = true;
  bool _error = false;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(userId).get();

        // Check user type
        String userType = userDoc.data()?['type'] ?? '';
        setState(() {
          _isAuthorized = (userType == 'y');
        });

        _firestore.collection('contacts').doc(userId).snapshots().listen((snapshot) async {
          if (snapshot.exists) {
            Map<String, dynamic>? data = snapshot.data();
            if (data != null) {
              Map<String, String> contacts = Map<String, String>.from(data);
              setState(() {
                _contacts = contacts;
              });
              await _fetchContactEmailsAndMessages(contacts);
            } else {
              setState(() {
                _contacts = {};
                _loading = false;
              });
            }
          } else {
            await _firestore.collection('contacts').doc(userId).set({});
            setState(() {
              _contacts = {};
              _loading = false;
            });
          }
        });
      } else {
        setState(() {
          _loading = false;
          _error = true;
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

  Future<void> _fetchContactEmailsAndMessages(Map<String, String> contacts) async {
    try {
      for (String receiverId in contacts.keys) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(receiverId).get();
        String email = userDoc.data()?['username'] ?? 'Unknown';

        setState(() {
          _contactEmails[receiverId] = email;
        });

        String channelId = contacts[receiverId]!;
        QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
        await _firestore
            .collection('messages')
            .doc(channelId)
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (messagesSnapshot.docs.isNotEmpty) {
          var message = messagesSnapshot.docs.first.data();
          setState(() {
            _latestMessages[receiverId] = message['text'] ?? 'No message';
          });
        }
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      print("Error fetching emails and latest messages: $e");
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _handleAddContact() {
    if (_isAuthorized) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const AddContactScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unavailable'),
          content: const Text('Parents please email us at ___@gmail.com to '
              'request a contact.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent[100]!, Colors.yellow[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Main contact list view
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _error
                ? const Center(child: Text('Error fetching contacts'))
                : _contacts.isEmpty
                ? const Center(child: Text('No contacts available'))
                : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                String receiverId =
                _contacts.keys.elementAt(index);
                String email =
                    _contactEmails[receiverId] ?? 'Unknown';
                String latestMessage =
                    _latestMessages[receiverId] ??
                        'No messages';

                return ListTile(
                  leading: const Icon(Icons.account_circle, size: 40),
                  title: Text(
                    email,
                    textHeightBehavior: const TextHeightBehavior(
                        leadingDistribution:
                        TextLeadingDistribution.even),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    latestMessage,
                    overflow: TextOverflow.ellipsis,
                  ),
                  tileColor: Colors.white24,
                  style: ListTileStyle.list,
                  minVerticalPadding: 15,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatterScreen(receiverId: receiverId),
                      ),
                    );
                  },
                );
              },
            ),
            // Floating action button for adding contacts
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _handleAddContact,
                backgroundColor: Colors.black87,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
