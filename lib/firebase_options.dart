// File generated for Firebase project yalla-5roga.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBs2U5GhebvvxQ6fHPvOD7PeN8QAVNc1-Q',
    appId: '1:847978310366:android:d1714ec0610ccc996cb04f',
    messagingSenderId: '847978310366',
    projectId: 'yalla-5roga',
    storageBucket: 'yalla-5roga.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCe261_PaBM4ShPA92gG_2_nX13V13q2Uo',
    appId: '1:847978310366:ios:5adcf5f57f6104866cb04f',
    messagingSenderId: '847978310366',
    projectId: 'yalla-5roga',
    storageBucket: 'yalla-5roga.firebasestorage.app',
    iosBundleId: 'com.example.yalla5roga',
  );
}
