import 'package:app/DemoScreen.dart';
import 'package:app/EmpListScreen.dart';
import 'package:app/EmpProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => EmpProvider(),
        child: EmpListScreen(),
      ),
    );
  }
}
