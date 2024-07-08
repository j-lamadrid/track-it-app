import 'package:flutter/material.dart';
import 'package:track_it/pages/home.dart';

class StrategyPage extends StatefulWidget {
  const StrategyPage({super.key, required this.title});

  final String title;

  @override
  State<StrategyPage> createState() => _StrategyPage();
}

class _StrategyPage extends State<StrategyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASE Strategies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Home Page')),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.blueAccent[100]!],
              // Adjust color shades as desired
              begin: Alignment.topLeft,
              // Change for different gradient directions
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.yellow[100]!],
              // Adjust color shades as desired
              begin: Alignment.topLeft,
              // Change for different gradient directions
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}
