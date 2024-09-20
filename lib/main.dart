import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/start/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'start/animation_start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  kFs.settings = const Settings(persistenceEnabled: true);

  runApp(const EmpireApp());
}

class EmpireApp extends StatelessWidget {
  const EmpireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'ElMessiri',
        ),
        home: const AnimationStart(),
      ),
    );
  }
}
