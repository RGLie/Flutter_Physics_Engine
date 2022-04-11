import 'package:flutter/material.dart';
import 'package:flutterphysics/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
      bodyColor: Colors.white70,
      displayColor: Colors.white70,
    );

    return MaterialApp(
      title: 'Flutter Physics World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black87,
          primarySwatch: Colors.indigo,
          textTheme: newTextTheme
      ),
      home: Physics(),
    );
  }
}

