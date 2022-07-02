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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBejpWsnzs7wGJ4ZJ8Lw5qDPseKGMcfF2U',
    appId: '1:142695772314:web:905ca6aa24f546911e6f23',
    messagingSenderId: '142695772314',
    projectId: 'facebattle-58d8c',
    authDomain: 'facebattle-58d8c.firebaseapp.com',
    storageBucket: 'facebattle-58d8c.appspot.com',
    measurementId: 'G-NJT38GT7M5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8c5Ywk1tF3NFVLgNxv7ngOdVfqxLzSD0',
    appId: '1:142695772314:android:77471516826773cc1e6f23',
    messagingSenderId: '142695772314',
    projectId: 'facebattle-58d8c',
    storageBucket: 'facebattle-58d8c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGrkixJZxVoUikPVrZAfz5DX6-Q3HX_T4',
    appId: '1:142695772314:ios:037611a21bf58fef1e6f23',
    messagingSenderId: '142695772314',
    projectId: 'facebattle-58d8c',
    storageBucket: 'facebattle-58d8c.appspot.com',
    iosClientId: '142695772314-hstvqsne4s32a610e2923a036difsdfs.apps.googleusercontent.com',
    iosBundleId: 'com.example.faceBattle',
  );
}
