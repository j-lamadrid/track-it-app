import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart';
import 'add_contact.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Map<String, Map<String, String>> _contacts =
      {}; // Stores contact details (email, type)
  final Map<String, String> _latestMessages = {};
  bool _loading = true;
  bool _error = false;
  bool _isAuthorized = false;
  DateTime? _startTime;

  void _trackTimeSpent(String pageName) async {
    if (_startTime != null) {
      Duration timeSpent = DateTime.now().difference(_startTime!);
      String userId = _auth.currentUser!.uid;
      DocumentReference pageDoc = _firestore
          .collection('stats')
          .doc(userId)
          .collection(pageName)
          .doc('stats');

      // Update time spent in Firestore
      pageDoc.set({
        'time': FieldValue.increment(timeSpent.inSeconds),
        // Add seconds to time
      }, SetOptions(merge: true));
    }
  }

  @override
  void dispose() {
    _trackTimeSpent('Contact Us');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _startTime = DateTime.now();
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

        _firestore
            .collection('contacts')
            .doc(userId)
            .snapshots()
            .listen((snapshot) async {
          if (snapshot.exists) {
            Map<String, dynamic>? data = snapshot.data();
            if (data != null) {
              Map<String, Map<String, String>> contacts = {};
              data.forEach((receiverId, details) {
                contacts[receiverId] = Map<String, String>.from(details);
              });
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

  Future<void> _fetchContactEmailsAndMessages(
      Map<String, Map<String, String>> contacts) async {
    try {
      for (String receiverId in contacts.keys) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(receiverId).get();
        String email = userDoc.data()?['username'] ?? 'Unknown';

        setState(() {
          _contacts[receiverId]!['email'] = email;
        });

        String channelId = contacts[receiverId]!['channelId']!;
        QuerySnapshot<Map<String, dynamic>> messagesSnapshot = await _firestore
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
          content: const Text(
              'Parents please email us at ___@gmail.com to request a contact.'),
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

  void _deleteContact(String receiverId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Contact?'),
          actions: [
            TextButton(
              onPressed: () {
                String userId = _auth.currentUser!.uid;
                _firestore.collection('contacts').doc(userId).update({
                  receiverId: FieldValue.delete(),
                });
                _firestore.collection('contacts').doc(receiverId).update({
                  userId: FieldValue.delete(),
                });
                setState(() {
                  _contacts.remove(receiverId);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _changeProviderType(String receiverId) {
    showDialog(
      context: context,
      builder: (context) {
        String newType = '';
        return AlertDialog(
          title: const Text('Change Provider Type'),
          content: DropdownButton<String>(
            value: newType.isEmpty ? null : newType,
            hint: const Text('Select provider type'),
            onChanged: (String? value) {
              setState(() {
                newType = value ?? '';
              });
            },
            items: const [
              DropdownMenuItem<String>(
                value: 'Primary',
                child: Text('Primary'),
              ),
              DropdownMenuItem<String>(
                value: 'Secondary',
                child: Text('Secondary'),
              ),
              DropdownMenuItem<String>(
                value: '',
                child: Text('Other'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newType.isNotEmpty) {
                  _firestore
                      .collection('contacts')
                      .doc(_auth.currentUser!.uid)
                      .update({
                    '$receiverId.type': newType,
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Change'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
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
                                  _contacts[receiverId]!['email'] ?? 'Unknown';
                              String type =
                                  _contacts[receiverId]!['type'] ?? 'Unknown';
                              String latestMessage =
                                  _latestMessages[receiverId] ?? 'No messages';

                              return Dismissible(
                                direction: DismissDirection.startToEnd,
                                key: Key(receiverId),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  _deleteContact(receiverId);
                                },
                                child: ListTile(
                                  leading: const Icon(Icons.account_circle,
                                      size: 40),
                                  title: Text(
                                    type.isNotEmpty
                                        ? '$type Provider: $email'
                                        : 'Provider: $email',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    latestMessage,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatterScreen(
                                          receiverId: receiverId,
                                          chatName: '$type Provider: $email',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
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
