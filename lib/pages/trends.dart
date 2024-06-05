import 'package:flutter/material.dart';
import 'package:track_it/pages/home.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key, required this.title});

  final String title;

  @override
  State<TrendsPage> createState() => _TrendsPage();
}

class _TrendsPage extends State<TrendsPage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.yellow[100]!], // Adjust color shades as desired
              begin: Alignment.topLeft, // Change for different gradient directions
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16.0, // Optional padding
                left: 16.0, // Optional padding
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 48.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home Page',)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}