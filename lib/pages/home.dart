import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:track_it/pages/contacts.dart';
import 'package:track_it/pages/my_day.dart';
import 'package:track_it/pages/trends.dart';
import 'package:track_it/pages/strategy.dart';
import 'package:track_it/pages/login_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    String userId = _auth.currentUser!.uid;
  }

  void _incrementTapCount(String pageName) async {
    String userId = _auth.currentUser!.uid;
    DocumentReference pageDoc = _firestore
        .collection('stats')
        .doc(userId)
        .collection(pageName)
        .doc('stats');

    pageDoc.set({
      'taps': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrackiT'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent[100]!, Colors.yellow[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Image.asset(
                  //  'lib/images/health_logo.png',
                  //  height: 75,
                  //  width: 250,
                  //),
                  const Text(
                    'Welcome Parent!',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const ImageIcon(
                                AssetImage('lib/images/calendar.png'),
                              ),
                              onPressed: () {
                                _incrementTapCount('Times of Day');
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const MyDayPage(
                                            title: 'My Day',
                                          )),
                                );
                              },
                              iconSize: 60.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Times of Day',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60), // Adjust space between columns
                      Column(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const ImageIcon(
                                AssetImage('lib/images/trends.png'),
                              ),
                              onPressed: () {
                                _incrementTapCount('Trends');
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const TrendsPage(
                                            title: 'Trends Over Time',
                                          )),
                                );
                              },
                              iconSize: 60.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Trends',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const ImageIcon(
                                AssetImage('lib/images/strategy.png'),
                              ),
                              onPressed: () {
                                _incrementTapCount('ASE Strategies');
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const StrategyPage(
                                            title: 'ASE Strategies',
                                          )),
                                );
                              },
                              iconSize: 60.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ASE Strategies',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60), // Adjust space between columns
                      Column(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const ImageIcon(
                                AssetImage('lib/images/manual.png'),
                              ),
                              onPressed: () {
                                _incrementTapCount('ASE Manual');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Unavailable'),
                                      content: const Text(
                                          'This page is currently in development.'),
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
                              },
                              iconSize: 60.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ASE Manual',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const ImageIcon(
                                AssetImage('lib/images/goals.png'),
                              ),
                              onPressed: () {
                                _incrementTapCount('Goals');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Unavailable'),
                                      content: const Text(
                                          'This page is currently in development.'),
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
                              },
                              iconSize: 60.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Goals',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60), // Adjust space between columns
                      Column(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const ImageIcon(
                                AssetImage('lib/images/contact.png'),
                              ),
                              onPressed: () {
                                _incrementTapCount('Contact Us');
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const ContactListScreen()),
                                );
                              },
                              iconSize: 60.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Contact Us',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 70, 15, 0),
                      child: Text(
                        'v0.4.6',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
