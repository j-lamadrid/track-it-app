import 'package:flutter/material.dart';
import 'package:track_it/auth_gate.dart';
import 'package:track_it/pages/transition_route_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrackiT!',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: const ColorScheme(
            primary: Colors.black,
            brightness: Brightness.light,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            secondary: Colors.white,
            error: Colors.yellow,
            onError: Colors.yellow,
            surface: Colors.white,
            onSurface: Colors.black,
        ),
        textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Colors.black),
        // fontFamily: 'SourceSansPro',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          displayLarge: TextStyle(fontFamily: 'Quicksand'),
          displayMedium: TextStyle(fontFamily: 'Quicksand'),
          headlineMedium: TextStyle(fontFamily: 'Quicksand'),
          headlineSmall: TextStyle(fontFamily: 'NotoSans'),
          titleLarge: TextStyle(fontFamily: 'NotoSans'),
          titleMedium: TextStyle(fontFamily: 'NotoSans'),
          bodyLarge: TextStyle(fontFamily: 'NotoSans'),
          bodyMedium: TextStyle(fontFamily: 'NotoSans'),
          titleSmall: TextStyle(fontFamily: 'NotoSans'),
          labelSmall: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      navigatorObservers: [TransitionRouteObserver()],
      home: const AuthGate(),
    );
  }
}