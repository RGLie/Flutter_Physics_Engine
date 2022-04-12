import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Physics extends StatefulWidget {
  const Physics({Key? key}) : super(key: key);

  @override
  _PhysicsState createState() => _PhysicsState();
}

class _PhysicsState extends State<Physics> with SingleTickerProviderStateMixin{
  bool isClick = false;
  bool isClickAfter = true;
  double mapY = 600;
  double mapX = 300;
  double elasticConstant = 0.7;
  List objList = [];
  List pathList=[];
  var ball = myBall(100, 200, 200, 0, 20, 1,0);
  var ball3 = myBall(150, 100, 0, 0, 20, 1, 0);
  var newball = myBall(200, 200, -200, 0, 25, 1.5, 0);


  late AnimationController _animationController;
  double baseTime = 0.016;
  int milliBaseTime = 16;
  double accel = 1000;

  List iPos = [];
  List fPos = [];

  double timerMilllisecond = 0;
  int longclickobj=0;


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
    //objList.add(ball3);
    objList.add(newball);

    for(var i=0; i<objList.length; i++){
      pathList.add(objList[i].draw);
    }

  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Bounce!!"),
        ),
        body: Center(
            child: GestureDetector(
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


                    for(var i =0; i<objList.length; i++){

                      if (!objList[i].isClick) {

                        checkCollapse(objList, baseTime);

                        objList[i].addYvel(baseTime * objList[i].yAcc);
                        objList[i].addXvel(baseTime * objList[i].xAcc);




                        objList[i].addAngle(baseTime*objList[i].angularVel);

                        wallInt = checkIsWall(objList[i]);
                        if(wallInt==1){

                          double wallCorrection = objList[i].yVel* baseTime +objList[i].yPos + objList[i].ballRad - mapY -1;
                          objList[i].yPos -= wallCorrection;
                          objList[i].mulYvel(-elasticConstant);
                          objList[i].mulXvel(elasticConstant);

                        }
                        else if(wallInt==2){
                          objList[i].mulXvel(-elasticConstant);
                          objList[i].mulYvel(elasticConstant);
                        }
                        else if(wallInt==0){
                          //print(objList[i].yVel);
                          objList[i].addYpos( objList[i].yVel * baseTime);
                          objList[i].addXpos( objList[i].xVel * baseTime);
                        }

                        objList[i].updateDraw();


                        // if (objList[i].yVel!=0 || objList[i].isClickAfter ) {
                        //   objList[i].addYvel(baseTime * accel);
                        //   //objList[i].subYpos(0.5 * accel * pow(baseTime, 2) - objList[i].yVel * baseTime);
                        //   objList[i].addYpos( objList[i].yVel * baseTime);
                        //   //objList[i].updateAnimation(_animationController.value);
                        //   objList[i].updateDraw();
                        //
                        //   objList[i].isClickAfter=false;
                        //   if ((objList[i].yVel* _animationController.value*baseTime + objList[i].yPos + objList[i].ballRad >= mapY) || (objList[i].yVel* _animationController.value*baseTime + objList[i].yPos - objList[i].ballRad <=0)) {
                        //     objList[i].mulYvel(-elasticConstant);
                        //     objList[i].mulXvel(elasticConstant);
                        //     //print("${newball.yVel}, ${newball.yPos}");
                        //     objList[i].outVel();
                        //   }
                        //
                        // }
                        //
                        // objList[i].addXpos( objList[i].xVel * baseTime);
                        // if ((objList[i].xVel* _animationController.value*baseTime + objList[i].xPos - objList[i].ballRad <=0)||(objList[i].xVel* _animationController.value*baseTime + objList[i].xPos + objList[i].ballRad >= mapX)) {
                        //
                        //   objList[i].mulXvel(-elasticConstant);
                        //   //print("${newball.yVel}, ${newball.yPos}");d
                        //   //objList[i].outVel();
                        // }
                        // objList[i].updateDraw();
                        // //objList[i].updateAnimation(_animationController.value);
                        //
                        // //print(ball.xVel);

                      }


                    }

                   //checkCollapse(objList, baseTime);


                    return Container(
                      width: mapX,

                      height: mapY,
                      color: Colors.white70,
                      child: CustomPaint(
                        painter: _paint(pathList: [ball.draw, newball.draw]),
                        //painter: _paint(pathList: [ball.draw, newball.draw, ball3.draw]),
                      ),
                    );
                  }
              ),
            )
        )
    );
  }



  bool checkCollapse(List<dynamic> objList, double baseTime) {

    for(int i=0; i<objList.length; i++) {
      for (int j = i + 1; j < objList.length; j++) {
        if (objList[i].objType == 'ball' && objList[j].objType == 'ball') {
          if (getDistance(objList[i], objList[j]) < (objList[i].ballRad + objList[j].ballRad)) {

            double correctDistance = (objList[i].ballRad + objList[j].ballRad) - getDistance(objList[i], objList[j]) +2;
            double eConstant = 0.8;

            double xi = objList[i].xPos;
            double yi = objList[i].yPos;
            List<double> iPos = [objList[i].xPos, objList[i].yPos];

            List<double> jPos = [objList[j].xPos, objList[j].yPos];

            List<double> rVec = [jPos[0]-iPos[0], jPos[1]-iPos[1]];
            List<double> rnorVec = [rVec[0]/sqrt(getL2norm(rVec)), rVec[1]/sqrt(getL2norm(rVec))];
            List<double> norVec = [rVec[1]/sqrt(rVec[0]*rVec[0] + rVec[1]*rVec[1]), -rVec[0]/sqrt(rVec[0]*rVec[0] + rVec[1]*rVec[1])];


            List<double> ipVVec = [objList[i].xVel, objList[i].yVel];
            List<double> jpVVec = [objList[j].xVel, objList[j].yVel];
            List<double> ijVVec = [ipVVec[0]-jpVVec[0], ipVVec[1]-jpVVec[1]];

            double viVal = getL2norm(ipVVec);
            double vjVal = getL2norm(jpVVec);


              objList[i].xPos -= (objList[j].mass/(objList[i].mass + objList[j].mass))* correctDistance *rnorVec[0];
              objList[i].yPos -=(objList[j].mass/(objList[i].mass + objList[j].mass))* correctDistance * rnorVec[1];

              objList[j].xPos += (objList[i].mass/(objList[i].mass + objList[j].mass))*correctDistance * rnorVec[0];
              objList[j].yPos += (objList[i].mass/(objList[i].mass + objList[j].mass))*correctDistance * rnorVec[1];



            double pulse = (-(1+eConstant)*innerProduct(ijVVec, norVec))/
                ((objList[i].rMass + objList[j].rMass) + (objList[i].ballRad*objList[i].ballRad)/objList[i].momentI + (objList[j].ballRad* objList[j].ballRad)/objList[j].momentI);


            double wi = objList[i].angularVel;
            double wj = objList[j].angularVel;

            objList[i].xVel = ipVVec[0] + pulse*objList[i].rMass*norVec[0];
            objList[i].yVel = ipVVec[1] + pulse*objList[i].rMass*norVec[1];
            objList[j].xVel = jpVVec[0] - pulse*objList[j].rMass*norVec[0];
            objList[j].yVel = jpVVec[1] - pulse*objList[j].rMass*norVec[1];

            objList[i].angularVel = wi + pulse * (objList[i].ballRad) / (objList[i].momentI);
            objList[j].angularVel = wj - pulse * (objList[j].ballRad) / (objList[j].momentI);

            return true;

          }
        }
      }
    }
    return false;

  }


  int checkIsWall( var obj){
    if ((obj.yVel* baseTime +obj.yPos + obj.ballRad >= mapY) ||
        (obj.yVel* baseTime + obj.yPos - obj.ballRad <=0)) {
          return 1;
    }
    else if ((obj.xVel*baseTime +obj.xPos + obj.ballRad >= mapX) ||
        (obj.xVel* baseTime + obj.xPos - obj.ballRad <=0)) {
      return 2;
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

  _paint({
    required this.pathList,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();

    for(var i=0; i<pathList.length; i++){
      path.addPath(pathList[i], Offset.zero);
    }
    canvas.drawPath(path, paint);
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
  late Path draw;
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
    draw=Path();
    for(double i=0; i<ballRad-1; i++){
      draw.arcTo(
          Rect.fromCircle(
            radius: i,
            center: Offset(
              super.xPos,
              super.yPos,
            ),
          ),
          0 + angle,
          1.9*pi + angle,
          true
      );

    }
    angularVel = w;
    momentI = 0.5 * mass * ballRad * ballRad;


  }


  bool isBallRegion(double checkX, double checkY){
    if((pow(super.xPos-checkX, 2)+pow(super.yPos-checkY, 2))<=pow(ballRad, 2)){
      return true;
    }
    return false;
  }

  void updateDraw(){
    draw=Path();
    for(double i=0; i<ballRad-1; i++){
      // draw.addOval(Rect.fromCircle(
      //     center: Offset(
      //       super.xPos,
      //       super.yPos,
      //     ),
      //     radius: i
      // ));

      draw.arcTo(
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

    }
  }

  void updateAnimation(double animationValue){
    draw=Path();
    for(double i=0; i<ballRad-1; i++){
      draw.addOval(Rect.fromCircle(
          center: Offset(
            super.xPos + animationValue*xVel*baseTime,
            super.yPos + animationValue*yVel*baseTime,
          ),
          radius: i
      ));
    }
  }
}
