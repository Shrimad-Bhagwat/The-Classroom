// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAWnvOvSZxLX6ekv2Vh0gygcQFyAl45ET8',
    appId: '1:739142156848:web:dda672b5a5ae36b951a3f5',
    messagingSenderId: '739142156848',
    projectId: 'the-classroom-15b52',
    authDomain: 'the-classroom-15b52.firebaseapp.com',
    databaseURL: 'https://the-classroom-15b52-default-rtdb.firebaseio.com',
    storageBucket: 'the-classroom-15b52.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhGqiIE1LAO_g0OltiYgZqap7EpRU_lUA',
    appId: '1:739142156848:android:2cc84a342c440b6651a3f5',
    messagingSenderId: '739142156848',
    projectId: 'the-classroom-15b52',
    databaseURL: 'https://the-classroom-15b52-default-rtdb.firebaseio.com',
    storageBucket: 'the-classroom-15b52.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqPxFgPcqwj21QRdGt7Y8CJrQGUVfsFwE',
    appId: '1:739142156848:ios:9181d2cbe163a3b751a3f5',
    messagingSenderId: '739142156848',
    projectId: 'the-classroom-15b52',
    databaseURL: 'https://the-classroom-15b52-default-rtdb.firebaseio.com',
    storageBucket: 'the-classroom-15b52.appspot.com',
    androidClientId: '739142156848-d6ibn4fv6mr8qdcumvhqi5l8jti0i5ru.apps.googleusercontent.com',
    iosClientId: '739142156848-864ugjnhku0svfgjngbivq02u821bo01.apps.googleusercontent.com',
    iosBundleId: 'com.shrimadbhagwat.theclassroom.theClassroom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqPxFgPcqwj21QRdGt7Y8CJrQGUVfsFwE',
    appId: '1:739142156848:ios:7b095fece52ae27f51a3f5',
    messagingSenderId: '739142156848',
    projectId: 'the-classroom-15b52',
    databaseURL: 'https://the-classroom-15b52-default-rtdb.firebaseio.com',
    storageBucket: 'the-classroom-15b52.appspot.com',
    androidClientId: '739142156848-d6ibn4fv6mr8qdcumvhqi5l8jti0i5ru.apps.googleusercontent.com',
    iosClientId: '739142156848-63avbd390ma074lkn1shs9mu9ckl3j7a.apps.googleusercontent.com',
    iosBundleId: 'com.shrimadbhagwat.theclassroom.theClassroom.RunnerTests',
  );
}