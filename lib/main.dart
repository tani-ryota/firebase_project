import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/App.dart';
import 'package:firebase_project/shift/main_page/shift_mainpage.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const shift(),
  );
}
