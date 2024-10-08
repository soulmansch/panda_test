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
    apiKey: 'AIzaSyDshCKI7pPpogidv5F96DbbvrKpaPI43hs',
    appId: '1:185449773863:web:ac305d0c507e0e41064702',
    messagingSenderId: '185449773863',
    projectId: 'privacies',
    authDomain: 'privacies.firebaseapp.com',
    storageBucket: 'privacies.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0IeFDmDXhx8zYbMUhO7Gf2_QRGbxLW0I',
    appId: '1:185449773863:android:469d8cee629908ca064702',
    messagingSenderId: '185449773863',
    projectId: 'privacies',
    storageBucket: 'privacies.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9hs2su7_yvypXQdJtnOfPQEGu3NxQlLc',
    appId: '1:185449773863:ios:d41d5e0ed8bdb352064702',
    messagingSenderId: '185449773863',
    projectId: 'privacies',
    storageBucket: 'privacies.appspot.com',
    iosBundleId: 'com.example.pandaEvents',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC9hs2su7_yvypXQdJtnOfPQEGu3NxQlLc',
    appId: '1:185449773863:ios:d41d5e0ed8bdb352064702',
    messagingSenderId: '185449773863',
    projectId: 'privacies',
    storageBucket: 'privacies.appspot.com',
    iosBundleId: 'com.example.pandaEvents',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDshCKI7pPpogidv5F96DbbvrKpaPI43hs',
    appId: '1:185449773863:web:bc9d0b7467947fe1064702',
    messagingSenderId: '185449773863',
    projectId: 'privacies',
    authDomain: 'privacies.firebaseapp.com',
    storageBucket: 'privacies.appspot.com',
  );
}
