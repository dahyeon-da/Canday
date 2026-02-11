import 'package:canday_frontend/src/screen/auth/intro.dart';
import 'package:canday_frontend/src/screen/diary/diaryMain.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Intro(),
      home: Diarymain(),
      debugShowCheckedModeBanner: false,
    );
  }
}
