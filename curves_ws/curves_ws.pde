// global variables
// modes: 0 natural cubic spline; 1 Hermite;
// 2 Catmull-Rom; 3 (degree 7) Bezier; 4 Cubic Bezier
int mode;

/*
 Completar la información para cada curva implementada

 Curva 1: <nombre>
 Implementado desde cero, adaptado o transcripción literal: Transcripción literal
 del código encontrado acá: <url>
*/


ControlPolygon poly;
ControlPoint grabber;
TangentPoint tangentGrabber;
ControlTangent tangents;
boolean drawGrid = true, drawCtrl = true;

void setup() {
  size(700, 700);
  textSize(20);
  poly = new ControlPolygon(2);
  tangents = new ControlTangent(poly.points);

  smooth();
}

void drawGrid(float gScale) {
  pushStyle();
  strokeWeight(1);
  int i;
  for (i=0; i<=width/gScale; i++) {
    stroke(0, 0, 0, 20);
    line(i*gScale, 0, i*gScale, height);
  }
  for (i=0; i<=height/gScale; i++) {
    stroke(0, 0, 0, 20);
    line(0, i*gScale, width, i*gScale);
  }
  popStyle();
}

void draw() {
  background(255, 255, 255);


  if (drawGrid)
    drawGrid(10);
  if (drawCtrl){
    poly.draw();
    tangents.draw();
    //curve.drawTangentLine();
  }

  HermiteCurve hermite = new HermiteCurve(poly.points, tangents.tPoints);
  hermite.drawHermiteCurve();

  switch(mode) {
  case 3:
    BezierCurveGrade6 curve6 = new BezierCurveGrade6(poly.points);
    curve6.drawBezierCurve();
    break;
  case 4:
    BezierCurve curve = new BezierCurve(poly.points);
    curve.drawBezierCurve(0);
    curve.drawBezierCurve(3);
    break;
  case 2:

    break;

  }

  // implement me
  // draw curve according to control polygon an mode




}

void keyPressed() {
  if (key == ' ')
    mode = mode < 4 ? mode+1 : 0;
  if (key == 'g')
    drawGrid = !drawGrid;
  if (key == 'c')
    drawCtrl = !drawCtrl;
}

void mousePressedT() {
  if (drawCtrl)
    for (TangentPoint p : tangents.tPoints) {
      if (grabber == null)
        if (p.grabsInput(mouseX, mouseY))
          tangentGrabber = p;
    } else
    tangentGrabber = null;
}

void mousePressed() {
  if (drawCtrl){
    for (ControlPoint p : poly.points) {
      if (grabber == null)
        if (p.grabsInput(mouseX, mouseY))
          grabber = p;
    }
    for (TangentPoint p : tangents.tPoints) {
      if (tangentGrabber == null)
        if (p.grabsInput(mouseX, mouseY))
          tangentGrabber = p;
    }
  }
    else{
    grabber = null;
    tangentGrabber = null;
  }

}

void mouseDragged() {
  if (grabber != null) {
    grabber.position.x = mouseX;
    grabber.position.y = mouseY;
  }
  if (tangentGrabber != null) {
    tangentGrabber.position.x = mouseX;
    tangentGrabber.position.y = mouseY;
  }
}

void mouseReleased() {
  grabber = null;
  tangentGrabber = null;
}
