import 'package:edge_alerts/edge_alerts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_it/pages/widgets/constants.dart';

// new message structure :
// Doc - channelId (userId) -> (to (id), from (id), time, content)
// Doc - psychId -> (channelIds)

// channelId == userId
// psychId -> [uid, uid, uid]
// messages -> uid -> (senderId, receiverId, time, content)
// for users: query messages for curr userId
// for providers: page with all connected users,
// select then query that users id

final _firestore = FirebaseFirestore.instance;
final _user = FirebaseAuth.instance.currentUser!;
String userId = _user.uid;
String? email = _user.email;
String messageText = '';
String psychId = '';
String? displayName = email?.split('@')[0];

class ChatterScreen extends StatefulWidget {
  const ChatterScreen({super.key});

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final chatMsgTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getPsychId();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      setState(() {
        email = user.email!;
        displayName = email?.split('@')[0];
      });
    } catch (e) {
      edgeAlert(context,
          title: 'Something Went Wrong',
          description: e.toString(),
          gravity: Gravity.bottom,
          icon: Icons.error,
          backgroundColor: Colors.black);
    }
  }

  void getPsychId() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('provider');

    try {
      DocumentSnapshot userRef = await ref.doc(userId).get();
      Map<String, dynamic>? data = userRef.data() as Map<String, dynamic>?;
      String? psychData = data?['psychId'];

      setState(() {
        psychId = psychData ?? '';
      });
    } catch (e) {
      print('Error getting psychId: $e');
      setState(() {
        psychId = '';
      });
    }
  }

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Service Unavailable'),
          content: const Text(
              'You are not yet connected with a provider in our system. '
                  'Please contact us at ___@___.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        title: const Text('Contact Us'),
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
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.yellow[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ChatStream(),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 2, bottom: 2),
                          child: TextField(
                            onChanged: (value) {
                              messageText = value;
                            },
                            controller: chatMsgTextController,
                            decoration: kMessageTextFieldDecoration,
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                      shape: const CircleBorder(),
                      color: Colors.black,
                      onPressed: () {
                        if (psychId.isEmpty) {
                          _showErrorDialog();
                          throw Exception();
                        }
                        chatMsgTextController.clear();
                        _firestore.collection('messages').add({
                          'sender': userId,
                          'text': messageText,
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                          'receiver': psychId,
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  const ChatStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
      _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final msgText = message['text'];
            final msgSenderId = message['sender'];
            final msgReceiverId = message['receiver'];
            MessageBubble msgBubble;

            if (msgSenderId == userId || msgReceiverId == userId) {
              if (msgSenderId == userId) {
                msgBubble = MessageBubble(
                  msgText: msgText,
                  msgSender: 'Parent',
                  user: true,
                );
              } else {
                msgBubble = MessageBubble(
                  msgText: msgText,
                  msgSender: 'Psychologist',
                  user: false,
                );
              }
              messageWidgets.add(msgBubble);
            }
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;

  const MessageBubble(
      {super.key,
        required this.msgText,
        required this.msgSender,
        required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
        user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              msgSender,
              style: const TextStyle(
                  fontSize: 13, fontFamily: 'OpenSans', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(50),
              topLeft:
              user ? const Radius.circular(50) : const Radius.circular(0),
              bottomRight: const Radius.circular(50),
              topRight:
              user ? const Radius.circular(0) : const Radius.circular(50),
            ),
            color: user ? Colors.white : Colors.grey[300],
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.black : Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
