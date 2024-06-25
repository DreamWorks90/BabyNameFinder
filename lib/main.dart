import 'dart:async';
import 'dart:convert';
import 'package:babyname/babypage.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MobileAds.instance.initialize();

  // Generate and store UDID and hashed UDID, and store hashed UDID in Firestore
  await _generateAndStoreUdid();

  runApp(const MyApp());
}

Future<void> _generateAndStoreUdid() async {
  final prefs = await SharedPreferences.getInstance();
  const udidKey = 'udid';
  const hashedUdidKey = 'hashed_udid';
  if (!prefs.containsKey(udidKey) || !prefs.containsKey(hashedUdidKey)) {
    var uuid = const Uuid();
    String udid = uuid.v4();
    String hashedUdid = _hashUdid(udid);
    await prefs.setString(udidKey, udid);
    await prefs.setString(hashedUdidKey, hashedUdid);
    await _storeHashedUdidInFirestore(hashedUdid); // Store hashed UDID in Firestore
  }
}

String _hashUdid(String udid) {
  var bytes = utf8.encode(udid); // data being hashed
  var digest = sha256.convert(bytes);
  return digest.toString();
}

Future<void> _storeHashedUdidInFirestore(String hashedUdid) async {
  final firestore = FirebaseFirestore.instance;
  final userDoc = firestore.collection('users').doc(hashedUdid);

  // Update the latest active session timestamp
  await userDoc.set({
    'latest_active_session': Timestamp.now(),
  }, SetOptions(merge: true));

  print('Stored or updated hashed UDID in Firestore: $hashedUdid');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Set the splash screen as the home page
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BabyPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA724F1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/babynames.png', // Use AssetImage for local images
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
