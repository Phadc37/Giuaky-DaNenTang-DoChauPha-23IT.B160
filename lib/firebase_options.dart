
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB_NX9MjJH0O6ramr6E4rkwilsjJ7lmz3Q',
    appId: '1:151890622475:web:21b03c3e8c1a6aebd6af0e',
    messagingSenderId: '151890622475',
    projectId: 'chau-pha',
    authDomain: 'chau-pha.firebaseapp.com',
    storageBucket: 'chau-pha.firebasestorage.app',
    measurementId: 'G-8YE3XERSG7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDekXiGcUQrmOpJqP0Ut5Z3NiO6RjhX5Z8',
    appId: '1:151890622475:android:ed0b9d039ba861fcd6af0e',
    messagingSenderId: '151890622475',
    projectId: 'chau-pha',
    storageBucket: 'chau-pha.firebasestorage.app',
  );
}
