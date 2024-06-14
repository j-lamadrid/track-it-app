// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDQpUjaa0Cb5HObHDQQOMJJbwcFtATc5iQ',
    appId: '1:758387738335:web:489ba19d4b2467fb6b0b6a',
    messagingSenderId: '758387738335',
    projectId: 'track-it-app-b875b',
    authDomain: 'track-it-app-b875b.firebaseapp.com',
    storageBucket: 'track-it-app-b875b.appspot.com',
    measurementId: 'G-6QKX2FMN6C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDogdWSIxFXqkKBbprFeyZ0mM7_ucAI958',
    appId: '1:758387738335:android:03b3719078d12ecd6b0b6a',
    messagingSenderId: '758387738335',
    projectId: 'track-it-app-b875b',
    storageBucket: 'track-it-app-b875b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtx-1yP6Zrd-I7ASvC1LlbkqM6NdLbf4A',
    appId: '1:758387738335:ios:ed7d3a8472a4de666b0b6a',
    messagingSenderId: '758387738335',
    projectId: 'track-it-app-b875b',
    storageBucket: 'track-it-app-b875b.appspot.com',
    iosBundleId: 'com.example.trackIt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtx-1yP6Zrd-I7ASvC1LlbkqM6NdLbf4A',
    appId: '1:758387738335:ios:ed7d3a8472a4de666b0b6a',
    messagingSenderId: '758387738335',
    projectId: 'track-it-app-b875b',
    storageBucket: 'track-it-app-b875b.appspot.com',
    iosBundleId: 'com.example.trackIt',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDQpUjaa0Cb5HObHDQQOMJJbwcFtATc5iQ',
    appId: '1:758387738335:web:b77f7a16028e67c56b0b6a',
    messagingSenderId: '758387738335',
    projectId: 'track-it-app-b875b',
    authDomain: 'track-it-app-b875b.firebaseapp.com',
    storageBucket: 'track-it-app-b875b.appspot.com',
    measurementId: 'G-HGGJKQF81D',
  );
}