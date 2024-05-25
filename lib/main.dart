import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrackiT',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            brightness: Brightness.light,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
            titleLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          scaffoldBackgroundColor: Colors.white, // Light gray background
          primaryIconTheme: const IconThemeData(color: Colors.white60), // White icons
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white60,
            foregroundColor: Colors.white,
          ),
        ),
        home: const MyHomePage(title: 'TrackiT Home Page')
    );
  }
}

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

      body: Center(
        child: Container(
          height: 600,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.blueAccent[400]!, Colors.lightBlue[100]!, Colors.yellow[400]!], // Adjust color shades as desired
              begin: Alignment.topLeft, // Change for different gradient directions
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center buttons vertically
              children: [
                const Text(
                  'Hello Parent!',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
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
                          AssetImage('lib/images/turn_taking.png'),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TurnTakingPage(title: 'Turn Taking',)),
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
                          AssetImage('lib/images/contact.png'),
                        ),
                        onPressed: () {
                          // Add functionality for button 1
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
                        'Turn Taking',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Contact Us',
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
                          AssetImage('lib/images/calendar.png'),
                        ),
                        onPressed: () {
                          // Add functionality for button 1
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
                          // Add functionality for button 1
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
                        'My Day',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Trends',
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
                          // Add functionality for button 1
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
                        'ASE Strategies',
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

class TurnTakingPage extends StatefulWidget {
  const TurnTakingPage({super.key, required this.title});

  final String title;

  @override
  State<TurnTakingPage> createState() => _TurnTakingPage();
}

class _TurnTakingPage extends State<TurnTakingPage> {

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
          height: 600,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.blueAccent[400]!, Colors.lightBlue[100]!, Colors.yellow[400]!], // Adjust color shades as desired
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
                icon: const Icon(Icons.home),
                iconSize: 60.0,
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