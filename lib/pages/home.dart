import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_it/pages/chat.dart';
import 'package:track_it/pages/chatter_screen.dart';
import 'package:track_it/pages/my_day.dart';
import 'package:track_it/pages/trends.dart';
import 'package:track_it/pages/contact.dart';
import 'package:track_it/pages/strategy.dart';
import 'package:track_it/pages/login_screen.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
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
              colors: [Colors.blueAccent[100]!, Colors.blueAccent[100]!], // Adjust color shades as desired
              begin: Alignment.topLeft, // Change for different gradient directions
              end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.yellow[100]!], // Adjust color shades as desired
              begin: Alignment.topLeft, // Change for different gradient directions
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center buttons vertically
              children: [
                const Text(
                  'Welcome Parent!',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        icon: const ImageIcon(
                          AssetImage('lib/images/calendar.png'),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyDayPage(title: 'My Day',)),
                          );
                        },
                        iconSize: 60.0,
                      ),
                    ),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        icon: const ImageIcon(
                          AssetImage('lib/images/trends.png'),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TrendsPage(title: 'Trends Over Time',)),
                          );
                        },
                        iconSize: 60.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Times of Day       ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '  Trends     ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        icon: const ImageIcon(
                          AssetImage('lib/images/strategy.png'),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StrategyPage(title: 'ASE Strategies',)),
                          );
                        },
                        iconSize: 60.0,
                      ),
                    ),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        icon: const ImageIcon(
                          AssetImage('lib/images/manual.png'),
                        ),
                        onPressed: () {
                          return;
                        },
                        iconSize: 60.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '   ASE Strategies    ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '   ASE Manual     ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        icon: const ImageIcon(
                          AssetImage('lib/images/goals.png'),
                        ),
                        onPressed: () {
                          return;
                        },
                        iconSize: 60.0,
                      ),
                    ),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.all(0),
                      child: IconButton(
                        icon: const ImageIcon(
                          AssetImage('lib/images/contact.png'),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChatterScreen()),
                          );
                        },
                        iconSize: 60.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '      Goals      ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '    Contact Us ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
              ]
          ),
        ),
      ),
    );
  }
}