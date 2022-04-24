import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterphysics/dimensions.dart';

class Physics extends StatefulWidget {
  const Physics({Key? key}) : super(key: key);

  @override
  _PhysicsState createState() => _PhysicsState();
}

class _PhysicsState extends State<Physics> with SingleTickerProviderStateMixin{
  bool isClick = false;
  bool isClickAfter = true;
  double mapY = Dimensions.physicMapY;
  double mapX= Dimensions.physicMapX;
  double elasticConstant = 0.8;
  List objList = [];
  List pathList=[];
  var ball = myBall(100, 200, 0, 0, 30, 0.5,0);
  var ball3 = myBall(150, 100, 00, 0, 20, 1, 0);
  var newball = myBall(200, 200, 0, 0, 30, 1, 0);

  // var ball = myBall(100, 200, 200, 0, 20, 1,0);
  // var ball3 = myBall(150, 100, 0, 0, 20, 1, 0);
  // var newball = myBall(200, 200, -300, 0, 20, 1, 0);

  late AnimationController _animationController;
  double baseTime = 0.016;
  int milliBaseTime = 16;
  double gravityAccel = 1000;
  double frictionC = 0.3;

  List iPos = [];
  List fPos = [];

  double timerMilllisecond = 0;
  int longclickobj=0;

  bool collapse = false;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();


    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1)
    );
    _animationController.repeat();

    objList.add(ball);
    //objList.add(newball);
    //objList.add(ball3);



  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
          onVerticalDragDown: (details) {
            for(var i =0; i<objList.length; i++){
              setState(() {
                if (objList[i].isBallRegion(details.localPosition.dx, details.localPosition.dy)) {
                  objList[i].isClick=true;
                  if (!objList[i].isLongClick) {
                    objList[i].stop();
                  }
                }
              });
            }
          },
          onVerticalDragEnd: (details) {
            for(var i =0; i<objList.length; i++){
              if (objList[i].isClick) {
                setState(() {
                  objList[i].isClick = false;
                  objList[i].isClickAfter = true;
                });
              }
            }
          },

          onLongPressDown: (details) {
            for(var i =0; i<objList.length; i++){
              setState(() {
                if (objList[i].isBallRegion(details.localPosition.dx, details.localPosition.dy)) {
                  iPos.add(details.localPosition.dx);
                  iPos.add(details.localPosition.dy);
                  objList[i].isLongClick=true;
                  longclickobj=i;
                }
              });
            }
          },
          onLongPressEnd: (details) {

            if (objList[longclickobj].isLongClick) {
              setState(() {


                objList[longclickobj].xVel=3*(details.localPosition.dx-iPos[0])/(0.7);
                objList[longclickobj].yVel=3*(details.localPosition.dy-iPos[1])/(0.7);

                objList[longclickobj].isLongClick=false;
                objList[longclickobj].isClick = false;
                objList[longclickobj].isClickAfter = true;


              });


            }

            iPos=[];
            fPos=[];

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Long Pressed Finish'),
              backgroundColor: Colors.indigoAccent,
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'Done',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ));

          },


          onVerticalDragUpdate: (details) {
            for(var i =0; i<objList.length; i++){
              if (objList[i].isClick) {
                setState(() {
                  objList[i].setPosition(details.localPosition.dx, details.localPosition.dy);
                  objList[i].updateDraw();
                });

              }
            }
          },

          child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                int wallInt = 0;
                bool Collapse = false;
                bool flag = false;
                double collapseTime = 0.016;



                for(var i =0; i<objList.length; i++){
                  if (!objList[i].isClick) {
                    objList[i].addYvel(baseTime * objList[i].yAcc);
                    objList[i].addXvel(baseTime * objList[i].xAcc);


                    checkCollapse(objList, baseTime);

                    wallInt = checkIsWall(objList[i]);

                    if(checkIsWall(objList[i])==1){
                      //print("sfgd");
                      //print(i);
                      //print(objList[i].xPos);
                      flag = true;

                      double wallCorrection = objList[i].yVel* baseTime +objList[i].yPos + objList[i].ballRad - mapY -1;
                      objList[i].yPos -= wallCorrection;

                      double vxi = objList[i].xVel;
                      double vyi = objList[i].yVel;

                      double xi = objList[i].xPos;
                      double yi = objList[i].yPos;


                      List<double> iPos = [xi, yi];

                      List<double> pPos = [xi, mapY];
                      List<double> ripVec = [pPos[0]-iPos[0], pPos[1]-iPos[1]];
                      List<double> ripNorVec = [ripVec[0]/sqrt(ripVec[0]*ripVec[0]+ripVec[1]*ripVec[1]), ripVec[1]/sqrt(ripVec[0]*ripVec[0]+ripVec[1]*ripVec[1])];

                      List<double> vipVec = [vxi,vyi];
                      List<double> vjpVec = [0,0];
                      List<double> vijVec = [vipVec[0]-vjpVec[0], vipVec[1]-vjpVec[1]];




                      // objList[i].xPos -= (objList[j].mass/(objList[i].mass + objList[j].mass))* correctDistance *rnorVec[0];
                      // objList[i].yPos -=(objList[j].mass/(objList[i].mass + objList[j].mass))* correctDistance * rnorVec[1];
                      //
                      // objList[j].xPos += (objList[i].mass/(objList[i].mass + objList[j].mass))*correctDistance * rnorVec[0];
                      // objList[j].yPos += (objList[i].mass/(objList[i].mass + objList[j].mass))*correctDistance * rnorVec[1];

                      // double pulse = (-(1+eConstant)*innerProduct(vijVec, ripNorVec))/
                      //     ((objList[i].rMass + objList[j].rMass)*innerProduct(ripNorVec, ripNorVec));



                      double pulse = (-(1+elasticConstant)*innerProduct(vijVec, ripNorVec))/
                          ((objList[i].rMass)*innerProduct(ripNorVec, ripNorVec) +
                              (innerProduct(ripVec, ripNorVec)*innerProduct(ripVec, ripNorVec))/objList[i].momentI);


                      double wi = objList[i].angularVel;
                      //
                      // objList[i].xVel = vipVec[0] + pulse*objList[i].rMass*ripNorVec[0];
                      // objList[i].yVel = vipVec[1] + pulse*objList[i].rMass*ripNorVec[1];

                      objList[i].mulYvel(-elasticConstant);
                      objList[i].mulXvel(elasticConstant);
                      //objList[i].angularVel = wi - pulse * innerProduct([ripVec[1], ripVec[0]], ripNorVec) / (objList[i].momentI);
                      objList[i].angularVel *= 0.7;

                    }
                    if(checkIsWall(objList[i])==2){
                      flag = true;
                      objList[i].mulYvel(-elasticConstant);
                      objList[i].mulXvel(elasticConstant);
                      objList[i].angularVel *= 0.8;
                    }
                    if(checkIsWall(objList[i])==3){
                      flag = true;
                      double wallCorrection = objList[i].xPos + objList[i].ballRad - mapX +1;
                      objList[i].xPos -= wallCorrection;
                      objList[i].mulXvel(-elasticConstant);
                      objList[i].mulYvel(elasticConstant);
                      objList[i].angularVel *= 0.7;
                    }
                    if(checkIsWall(objList[i])==4){
                      flag = true;
                      double wallCorrection = -objList[i].xPos + objList[i].ballRad +1 ;
                      objList[i].xPos += wallCorrection;
                      objList[i].mulXvel(-elasticConstant);
                      objList[i].mulYvel(elasticConstant);
                      objList[i].angularVel *= 0.7;
                    }
                    if(!flag&&(checkIsWall(objList[i])==0)){
                      //print(objList[i].yVel);
                      objList[i].addYpos( objList[i].yVel * baseTime);
                      objList[i].addXpos( objList[i].xVel * baseTime);
                    }


                    objList[i].angularVel += baseTime * objList[i].angularAcc;
                    objList[i].addAngle(baseTime*objList[i].angularVel);


                    flag = false;


                  }

                  objList[i].updateDraw();
                }

                //checkCollapse(objList, baseTime);


                return Container(
                  width: mapX,
                  height: mapY,
                  //color: Colors.white70,
                  child: CustomPaint(
                    //painter: _paint(pathList: [ball.draw, newball.draw]),
                    painter: _paint(pathList: [ball.draws], paintList: [ball.paints]),
                    //painter: _paint(pathList: [ball.draws, newball.draws, ball3.draws], paintList: [ball.paints, newball.paints, ball3.paints]),
                  ),
                );
              }
          ),
        );
  }



  void checkCollapse(List<dynamic> objList, double baseTime) {

    for(int i=0; i<objList.length; i++) {
      for (int j = i + 1; j < objList.length; j++) {

        if (getDistance(objList[i], objList[j]) < (objList[i].ballRad + objList[j].ballRad)) {


            double correctDistance =0.5*( (objList[i].ballRad + objList[j].ballRad) - getDistance(objList[i], objList[j]) +2);

            double eConstant = 0.7;


            double vxi = objList[i].xVel;
            double vyi = objList[i].yVel;
            double vxj = objList[j].xVel;
            double vyj = objList[j].yVel;

            double xi = objList[i].xPos;
            double yi = objList[i].yPos;
            double xj = objList[j].xPos;
            double yj = objList[j].yPos;

            double ri = objList[i].ballRad;
            double rj = objList[j].ballRad;

            List<double> iPos = [xi, yi];
            List<double> jPos = [xj, yj];

            List<double> pPos = [(ri*xj+rj*xi)/(ri+rj), (ri*yj+rj*yi)/(ri+rj)];
            List<double> ripVec = [pPos[0]-iPos[0], pPos[1]-iPos[1]];
            List<double> ripNorVec = [ripVec[0]/sqrt(ripVec[0]*ripVec[0]+ripVec[1]*ripVec[1]), ripVec[1]/sqrt(ripVec[0]*ripVec[0]+ripVec[1]*ripVec[1])];
            List<double> rjpVec = [pPos[0]-jPos[0], pPos[1]-jPos[1]];
            List<double> rjpNorVec = [rjpVec[0]/sqrt(rjpVec[0]*rjpVec[0]+rjpVec[1]*rjpVec[1]), rjpVec[1]/sqrt(rjpVec[0]*rjpVec[0]+rjpVec[1]*rjpVec[1])];

            List<double> vipVec = [vxi,vyi];
            List<double> vjpVec = [vxj,vyj];
            List<double> vijVec = [vipVec[0]-vjpVec[0], vipVec[1]-vjpVec[1]];




            // objList[i].xPos -= (objList[j].mass/(objList[i].mass + objList[j].mass))* correctDistance *rnorVec[0];
            // objList[i].yPos -=(objList[j].mass/(objList[i].mass + objList[j].mass))* correctDistance * rnorVec[1];
            //
            // objList[j].xPos += (objList[i].mass/(objList[i].mass + objList[j].mass))*correctDistance * rnorVec[0];
            // objList[j].yPos += (objList[i].mass/(objList[i].mass + objList[j].mass))*correctDistance * rnorVec[1];

            double viScala=sqrt(vxi*vxi+vyi*vyi);
            double vjScala=sqrt(vxj*vxj+vyj*vyj);

            objList[i].xPos -= (viScala/(viScala + vjScala))* correctDistance *ripNorVec[0];
            objList[i].yPos -=(viScala/(viScala + vjScala))* correctDistance * ripNorVec[1];

            objList[j].xPos -= (vjScala/(viScala + vjScala))*correctDistance * rjpNorVec[0];
            objList[j].yPos -= (vjScala/(viScala + vjScala))*correctDistance * rjpNorVec[1];


            // double pulse = (-(1+eConstant)*innerProduct(vijVec, ripNorVec))/
            //     ((objList[i].rMass + objList[j].rMass)*innerProduct(ripNorVec, ripNorVec));

            double pulse = (-(1+eConstant)*innerProduct(vijVec, ripNorVec))/
                ((objList[i].rMass + objList[j].rMass)*innerProduct(ripNorVec, ripNorVec) +
                    (innerProduct(ripVec, rjpNorVec)*innerProduct(ripVec, rjpNorVec))/objList[i].momentI +
                    (innerProduct(rjpVec, rjpNorVec)*innerProduct(rjpVec, rjpNorVec))/objList[j].momentI);


            double wi = objList[i].angularVel;
            double wj = objList[j].angularVel;
            //
            objList[i].xVel = vipVec[0] + pulse*objList[i].rMass*ripNorVec[0];
            objList[i].yVel = vipVec[1] + pulse*objList[i].rMass*ripNorVec[1];
            objList[j].xVel = vjpVec[0] + pulse*objList[j].rMass*rjpNorVec[0];
            objList[j].yVel = vjpVec[1] + pulse*objList[j].rMass*rjpNorVec[1];

            objList[i].angularVel = wi + pulse * innerProduct([ripVec[1], ripVec[0]], ripNorVec) / (objList[i].momentI);
            objList[j].angularVel = wj - pulse * innerProduct([rjpVec[1], rjpVec[0]], ripNorVec) / (objList[j].momentI);

          }



      }
    }

  }


  int checkIsWall( var obj){
    if (obj.yVel* baseTime +obj.yPos + obj.ballRad >= mapY){
      return 1;
    }
    else if(obj.yVel* baseTime + obj.yPos - obj.ballRad <=0) {
      return 2;
    }
    else if (obj.xVel*baseTime +obj.xPos + obj.ballRad >= mapX){
      return 3;
    }
    else if(obj.xVel* baseTime + obj.xPos - obj.ballRad <=0) {
      return 4;
    }

    return 0;
  }

}


double getL2norm(List vec){
  return vec[0]*vec[0]+ vec[1]*vec[1];
}

double innerProduct(List vec1, List vec2){
  return vec1[0]*vec2[0] + vec1[1]*vec2[1];
}


double getDistance(physicsObject obj1, physicsObject obj2){
  return sqrt((obj1.xPos-obj2.xPos)*(obj1.xPos-obj2.xPos) + (obj1.yPos-obj2.yPos)*(obj1.yPos-obj2.yPos));
}


class _paint extends CustomPainter {
  final List pathList;
  final List paintList;

  _paint({
    required this.pathList,
    required this.paintList,
  });

  @override
  void paint(Canvas canvas, Size size) {


    Path path = Path();

    for(var i=0; i<pathList.length; i++){
      canvas.drawShadow(pathList[i][0], Colors.grey, sqrt(10), false);
      //path.addPath(pathList[i], Offset.zero);
      canvas.drawPath(pathList[i][0], paintList[i][0]);
      canvas.drawPath(pathList[i][1], paintList[i][1]);

    }
    //canvas.drawPath(path, paintList[i][0]);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}


class physicsObject{
  double xPos = 0;
  double yPos = 0;
  double xVel = 0;
  double yVel = 0;
  double xAcc = 0;
  double yAcc = 1000;
  double angle = 0;
  double angularVel = 0;
  double angularAcc = 0;

  double mass = 1;
  double rMass=1;
  double baseTime = 0.016;
  double elasticConstant = 1;
  bool isClick = false;
  bool isClickAfter = true;
  bool isLongClick = false;

  void addXpos(double x){
    xPos+=x;
  }

  void subXpos(double x){
    xPos-=x;
  }

  void addYpos(double y){
    yPos+=y;
  }

  void subYpos(double y){
    yPos-=y;
  }

  void addXvel(double x){
    xVel+=x;
  }

  void subXvel(double x){
    xVel-=x;
  }

  void addYvel(double y){
    yVel+=y;
  }

  void subYvel(double y){
    yVel-=y;
  }


  void mulXvel(double v){
    xVel*=v;
  }

  void mulYvel(double v){
    yVel*=v;
  }

  void stop(){
    xVel=0;
    yVel=0;
  }

  void outVel(){
    if(yVel.abs()<6.6){
      yVel=0;
    }
    if(xVel.abs()<6.6){
      xVel=0;
    }
  }

  void setPosition(double x, double y){
    xPos=x;
    yPos=y;
  }

  void addAngle(double ang){
    angle += ang;
  }
}



class myBall extends physicsObject{
  late double ballRad;
  List<Path> draws = [];
  List<Paint> paints= [];

  String objType = 'ball';
  late double momentI;

  myBall(double xp, double yp, double xv, double yv, double br, double m, double w){
    super.xPos=xp;
    super.yPos = yp;
    super.xVel = xv;
    super.yVel = yv;
    super.mass = m;
    super.rMass = 1/m;
    ballRad = br;
    Path draw1=Path();
    Path draw2=Path();
    for(double i=0; i<ballRad-1; i++){
      draw1.arcTo(
          Rect.fromCircle(
            radius: i,
            center: Offset(
              super.xPos,
              super.yPos,
            ),
          ),
          0 + angle,
          (1.9*pi),
          true
      );

      draw2.arcTo(
          Rect.fromCircle(
            radius: i,
            center: Offset(
              super.xPos,
              super.yPos,
            ),
          ),
          1.9*pi + angle,
          0.1*pi,
          true
      );

    }
    angularVel = w;
    momentI = 0.5 * mass * ballRad * ballRad;

    Paint paint1 =  Paint()
      ..color = Color(0xffcce0ff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Paint paint2 =  Paint()
      ..color = Color(0xffb0cfff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    paints.add(paint1);
    paints.add(paint2);

    draws.add(draw1);
    draws.add(draw2);


  }


  bool isBallRegion(double checkX, double checkY){
    if((pow(super.xPos-checkX, 2)+pow(super.yPos-checkY, 2))<=pow(ballRad, 2)){
      return true;
    }
    return false;
  }

  void updateDraw(){
    Path draw1=Path();
    Path draw2=Path();

    for(double i=0; i<ballRad-1; i++){
      // draw.addOval(Rect.fromCircle(
      //     center: Offset(
      //       super.xPos,
      //       super.yPos,
      //     ),
      //     radius: i
      // ));

      draw1.arcTo(
          Rect.fromCircle(
            radius: i,
            center: Offset(
              super.xPos,
              super.yPos,
            ),
          ),
          0 + angle,
          (1.9*pi),
          true
      );

      draw2.arcTo(
          Rect.fromCircle(
            radius: i,
            center: Offset(
              super.xPos,
              super.yPos,
            ),
          ),
          1.9*pi + angle,
          0.1*pi,
          true
      );
    }
    draws[0]=draw1;
    draws[1]=draw2;
  }

}