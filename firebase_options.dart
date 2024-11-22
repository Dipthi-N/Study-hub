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
    apiKey: 'AIzaSyBrEGqn7obIag-3orRf0zyIrGJED8MWFv4',
    appId: '1:208174433513:web:5c8e261ae9fb20c63b1c78',
    messagingSenderId: '208174433513',
    projectId: 'study-hub-5e88d',
    authDomain: 'study-hub-5e88d.firebaseapp.com',
    storageBucket: 'study-hub-5e88d.appspot.com',
    measurementId: 'G-HJR8HV0CWQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvdUkfONY14pGhPKCAUC_FsW7dUi9hNsk',
    appId: '1:208174433513:android:be62b740a54fcca53b1c78',
    messagingSenderId: '208174433513',
    projectId: 'study-hub-5e88d',
    storageBucket: 'study-hub-5e88d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBm4Qs-q1aiaeSF7myd842fAzWHop4L1nM',
    appId: '1:208174433513:ios:a4ae0d1ffc963ba13b1c78',
    messagingSenderId: '208174433513',
    projectId: 'study-hub-5e88d',
    storageBucket: 'study-hub-5e88d.appspot.com',
    iosBundleId: 'com.example.studyhub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBm4Qs-q1aiaeSF7myd842fAzWHop4L1nM',
    appId: '1:208174433513:ios:a4ae0d1ffc963ba13b1c78',
    messagingSenderId: '208174433513',
    projectId: 'study-hub-5e88d',
    storageBucket: 'study-hub-5e88d.appspot.com',
    iosBundleId: 'com.example.studyhub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBrEGqn7obIag-3orRf0zyIrGJED8MWFv4',
    appId: '1:208174433513:web:5c8e261ae9fb20c63b1c78',
    messagingSenderId: '208174433513',
    projectId: 'study-hub-5e88d',
    authDomain: 'study-hub-5e88d.firebaseapp.com',
    storageBucket: 'study-hub-5e88d.appspot.com',
    measurementId: 'G-HJR8HV0CWQ',
  );

}