import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutterphysics/colors.dart';
import 'package:flutterphysics/home_page.dart';
import 'package:flutterphysics/physics.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:responsive_builder/responsive_builder.dart';

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

    return GetMaterialApp(
      title: 'Flutter Physics World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: colorLibrary.mainColor,
          //primarySwatch: Colors.indigo,
          textTheme: newTextTheme
      ),

      home: ScreenTypeLayout(
          desktop: HomePage(),
        mobile: HomePage(),
      )
    );
  }
}
