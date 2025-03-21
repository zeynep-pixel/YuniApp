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
    apiKey: 'AIzaSyDOYvVonspIrdPXNsqfGe4i-l9Jbmq4dmA',
    appId: '1:625397493929:web:354997c036a5b3e07179b8',
    messagingSenderId: '625397493929',
    projectId: 'yuapp-a8cec',
    authDomain: 'yuapp-a8cec.firebaseapp.com',
    storageBucket: 'yuapp-a8cec.firebasestorage.app',
    measurementId: 'G-DGVDNW4J2F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZdKEpjpkWki2wsfm4IikF7vxXGOyyADs',
    appId: '1:625397493929:android:9839d1002cff132e7179b8',
    messagingSenderId: '625397493929',
    projectId: 'yuapp-a8cec',
    storageBucket: 'yuapp-a8cec.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdvZ8PFQ7nIbJJV_0p-HeyqrjpnPTnykc',
    appId: '1:625397493929:ios:0f823ddb126c115a7179b8',
    messagingSenderId: '625397493929',
    projectId: 'yuapp-a8cec',
    storageBucket: 'yuapp-a8cec.firebasestorage.app',
    iosBundleId: 'com.example.yuApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCdvZ8PFQ7nIbJJV_0p-HeyqrjpnPTnykc',
    appId: '1:625397493929:ios:0f823ddb126c115a7179b8',
    messagingSenderId: '625397493929',
    projectId: 'yuapp-a8cec',
    storageBucket: 'yuapp-a8cec.firebasestorage.app',
    iosBundleId: 'com.example.yuApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDOYvVonspIrdPXNsqfGe4i-l9Jbmq4dmA',
    appId: '1:625397493929:web:45a1ab9bb988f9537179b8',
    messagingSenderId: '625397493929',
    projectId: 'yuapp-a8cec',
    authDomain: 'yuapp-a8cec.firebaseapp.com',
    storageBucket: 'yuapp-a8cec.firebasestorage.app',
    measurementId: 'G-W7QQ1XRHBZ',
  );
}
