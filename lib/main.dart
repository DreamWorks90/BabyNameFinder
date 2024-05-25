import 'dart:async';
import 'dart:convert';
import 'package:babyname/babypage.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'db/database_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("before firebase");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("after firebase");
  await MobileAds.instance.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dbHelper = DatabaseHelper();
  String filePath = 'assets/babynames.csv'; // Example file path
  await dbHelper.importCsvData(filePath);

  // Generate and store UDID and hashed UDID
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
    print('Generated UDID: $udid');
    print('Generated and hashed UDID: $hashedUdid');
  } else {
    String? udid = prefs.getString(udidKey);
    String? hashedUdid = prefs.getString(hashedUdidKey);
    print('Existing UDID: $udid');
    print('Existing hashed UDID: $hashedUdid');
  }
}

String _hashUdid(String udid) {
  var bytes = utf8.encode(udid); // data being hashed
  var digest = sha256.convert(bytes);
  return digest.toString();
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
            // Replace 'assets/logo.svg' with the path to your SVG file
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
