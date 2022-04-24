import 'package:get/get.dart';

class Dimensions{
  static double screenHeight=Get.context!.height;
  static double screenWidth=Get.context!.width;

  //screensize=844, pageheight=220 --> 844/220=3.8
  static double physicMapY = screenHeight*(4/6);
  static double physicMapX = screenWidth*(5/8);
  static double widthEdge=screenWidth*(1/12);
  static double heightEdge=screenHeight*(1/20);



}