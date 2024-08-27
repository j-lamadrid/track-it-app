import 'package:edge_alerts/edge_alerts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_it/pages/contacts.dart';
import 'package:track_it/pages/widgets/constants.dart';

// new message structure :
// Doc - channelId (userId) -> (to (id), from (id), time, content)

final _firestore = FirebaseFirestore.instance;
final _user = FirebaseAuth.instance.currentUser!;
String userId = _user.uid;
String? email = _user.email;
String messageText = '';
String psychId = '';
String? displayName = email?.split('@')[0];

class ChatterScreen extends StatefulWidget {
  final String receiverId;

  const ChatterScreen({Key? key, required this.receiverId}) : super(key: key);

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final chatMsgTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late String userId;
  String messageText = '';

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContactListScreen(userId: userId)),
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
          child: Column(
            children: [
              Expanded(
                child: ChatStream(
                  userId: userId,
                  receiverId: widget.receiverId,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: kMessageContainerDecoration,
                child: Row(
                  children: [
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
                        _firestore.collection('messages').add({
                          'sender': userId,
                          'receiver': widget.receiverId,
                          'text': messageText,
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                        });
                        chatMsgTextController.clear();
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
  final String userId;
  final String receiverId;

  const ChatStream({Key? key, required this.userId, required this.receiverId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('sender', isEqualTo: userId)
          .where('receiver', isEqualTo: receiverId)
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageWidgets = [];

          for (var message in messages) {
            final msgText = message['text'];
            final msgSenderId = message['sender'];

            final msgBubble = MessageBubble(
              msgText: msgText,
              msgSender: msgSenderId == userId ? 'You' : 'Contact',
              user: msgSenderId == userId,
            );
            messageWidgets.add(msgBubble);
          }

          return ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            children: messageWidgets,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
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
