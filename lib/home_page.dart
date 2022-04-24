import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutterphysics/colors.dart';
import 'package:flutterphysics/dimensions.dart';
import 'package:flutterphysics/physics.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.light,
        theme: const NeumorphicThemeData(
          baseColor: Color(0xffcce0ff),
          lightSource: LightSource.topLeft,
          depth: 10,
        ),
        darkTheme: const NeumorphicThemeData(
          baseColor: Color(0xFF3E3E3E),
          lightSource: LightSource.topLeft,
          depth: 6,
        ),
        home: Scaffold(
          body: _buldBody(),
        )
    );

  }

  Widget _buldBody() {
    return Container(
      padding: EdgeInsets.only(left: Dimensions.widthEdge, right: Dimensions.widthEdge, top: Dimensions.heightEdge, bottom: Dimensions.heightEdge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              NeumorphicText(
                "Flutter Physics",
                style: NeumorphicStyle(
                  depth: 3,  //customize depth here
                  color: colorLibrary.myColor, //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 40, //customize size here
                  fontWeight: FontWeight.w800,
                  fontFamily: 'OpenSans',

                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
              ),

              NeumorphicButton(
                onPressed: () {
                  print("onClick");
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.favorite_border,
                  //color: _iconsColor(context),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 50,
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
                        depth: -6,
                        lightSource: LightSource.topLeft,
                        color: colorLibrary.myDepthColor
                    ),
                    child: Physics()
                ),

                Column(
                  children: [
                    Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                            depth: 8,
                            lightSource: LightSource.topLeft,
                            color: colorLibrary.myColor
                        ),
                        child: Container(
                          width: 200,
                          height: 100,
                        )
                    ),
yp
                    Row(
                      children: [

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NeumorphicButton(
                              onPressed: () {
                                print("onClick");
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.favorite_border,
                                  //color: _iconsColor(context),
                                ),
                              ),
                            ),

                            NeumorphicButton(
                              onPressed: () {
                                print("onClick");
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.favorite_border,
                                  //color: _iconsColor(context),
                                ),
                              ),
                            ),

                            NeumorphicButton(
                              onPressed: () {
                                print("onClick");
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.favorite_border,
                                  //color: _iconsColor(context),
                                ),
                              ),
                            ),

                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NeumorphicButton(
                              onPressed: () {
                                print("onClick");
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.favorite_border,
                                  //color: _iconsColor(context),
                                ),
                              ),
                            ),

                            NeumorphicButton(
                              onPressed: () {
                                print("onClick");
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.favorite_border,
                                  //color: _iconsColor(context),
                                ),
                              ),
                            ),

                            NeumorphicButton(
                              onPressed: () {
                                print("onClick");
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.favorite_border,
                                  //color: _iconsColor(context),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),


                  ],
                )
              ],
            ),
          ),



        ],
      ),
    );
  }
}
