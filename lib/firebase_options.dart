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
    apiKey: 'AIzaSyCumzB24PT5pzfAGfgbmK_lKS9arTgSI-w',
    appId: '1:1086255448541:web:690959dec424eb9e84f634',
    messagingSenderId: '1086255448541',
    projectId: 'materias-app-2ab7f',
    authDomain: 'materias-app-2ab7f.firebaseapp.com',
    storageBucket: 'materias-app-2ab7f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAntWWR-RqhwQgKmsJ0FxqJ1ZcwHTefhmo',
    appId: '1:1086255448541:android:d45c6612ef7e099484f634',
    messagingSenderId: '1086255448541',
    projectId: 'materias-app-2ab7f',
    storageBucket: 'materias-app-2ab7f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsF8YixXP3UnlLeponbijqbNgPsiXriRY',
    appId: '1:1086255448541:ios:914aa3bcec374c3084f634',
    messagingSenderId: '1086255448541',
    projectId: 'materias-app-2ab7f',
    storageBucket: 'materias-app-2ab7f.appspot.com',
    iosClientId: '1086255448541-nm6spbu6fe04i5c8cu15jlgq20gkuo07.apps.googleusercontent.com',
    iosBundleId: 'com.example.materiapp',
  );
}
