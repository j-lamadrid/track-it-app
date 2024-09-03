import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'contacts.dart';
import 'widgets/constants.dart';

class ChatterScreen extends StatefulWidget {
  final String receiverId;

  const ChatterScreen({super.key, required this.receiverId});

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final chatMsgTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late String userId;
  late String receiverId;
  late String receiverName;
  String? channelId;
  String messageText = '';

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid;
    receiverId = widget.receiverId;
  }

  Future<String?> _getChannelId() async {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
        .collection('users')
        .doc(receiverId)
        .get();
    receiverName = userDoc.data()?['username'] ?? 'Unknown';
    DocumentSnapshot<Map<String, dynamic>> contactDoc =
        await _firestore.collection('contacts').doc(userId).get();
    return contactDoc.data()?[widget.receiverId];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
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
      body: FutureBuilder<String?>(
        future: _getChannelId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching chat data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No chat channel found'));
          } else {
            channelId = snapshot.data!;
            return SizedBox.expand(
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
                        receiverName: receiverName,
                        channelId: channelId!,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
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
                              if (messageText.isNotEmpty) {
                                _firestore
                                    .collection('messages')
                                    .doc(channelId)
                                    .collection('chats')
                                    .add({
                                  'sender': userId,
                                  'receiver': widget.receiverId,
                                  'text': messageText,
                                  'timestamp':
                                      DateTime.now().millisecondsSinceEpoch,
                                  'isRead': false,
                                });
                                chatMsgTextController.clear();
                              }
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
            );
          }
        },
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  final String userId;
  final String receiverName;
  final String channelId;

   const ChatStream(
      {super.key,
      required this.userId,
      required this.receiverName,
      required this.channelId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(channelId)
          .collection('chats')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs;
          List<MessageBubble> messageWidgets = [];

          for (var message in messages) {
            final msgText = message['text'];
            final msgSenderId = message['sender'];

            final msgBubble = MessageBubble(
              msgText: msgText,
              msgSender: msgSenderId == userId ? 'You' : receiverName,
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

  const MessageBubble({
    super.key,
    required this.msgText,
    required this.msgSender,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          //Container(
          //  padding: const EdgeInsets.symmetric(horizontal: 10),
          //  child: Text(
          //    msgSender,
          //    style: const TextStyle(
          //        fontSize: 13, fontFamily: 'OpenSans', color: Colors.black87),
          //  ),
          //),
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
