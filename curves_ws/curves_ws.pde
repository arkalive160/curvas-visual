// global variables
// modes: 0 natural cubic spline; 1 Hermite;
// 2 Catmull-Rom; 3 (degree 7) Bezier; 4 Cubic Bezier
int mode;

/*
 Completar la información para cada curva implementada

 Curva 0: <Cubica Natural>
 Matrix.pde codigo de terceros proveeido por el monitor de la materia
 curva cubica naural implementada en colaboracion con sebastian morales garzon
 https://www.math.ntnu.no/emner/TMA4215/2008h/cubicsplines.pdf

 Curva 1: <Hermite>
 implementada desde 0 basada en bezier6, en colaboracion con sebastian morales garzon
 https://en.wikipedia.org/wiki/Cubic_Hermite_spline

Curva 2: <Catmull-Rom>
Implementacion desde 0 basada en Hermite, en colaboracion con sebastian morales garzon
https://en.wikipedia.org/wiki/Cubic_Hermite_spline

Curva 4 <Bezier grado 6>
Implementacion desde 0 basada en Bezier Cubica, en colaboracion con sebastian morales garzon
https://en.wikipedia.org/wiki/B%C3%A9zier_curve

Curva 5: <Bezier Cubica>
Implementacion basada en codigo C# de la pagina http://devmag.org.za/2011/04/05/bzier-curves-a-tutorial/
https://en.wikipedia.org/wiki/B%C3%A9zier_curve



*/


ControlPolygon poly;
ControlPoint grabber;
ControlPolygon aux;
TangentPoint tangentGrabber;
ControlTangent tangents;
boolean drawGrid = true, drawCtrl = true;

void setup() {
  size(700, 700);
  textSize(20);
  poly = new ControlPolygon(7);
  tangents = new ControlTangent(poly.points);
  aux = new ControlPolygon(7);

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
    //curve.drawTangentLine();
  }



  switch(mode) {

  case 0:
    NaturalCubic naturalc = new NaturalCubic(poly.points, aux.points);
    naturalc.calculateDerivates();
  break;
  case 1:
    Catmull catmull = new Catmull(poly.points, tangents.tPoints);
    catmull.drawCatmullCurve();
  break;
  case 2:
    tangents.draw();
    HermiteCurve hermite = new HermiteCurve(poly.points, tangents.tPoints);
    hermite.drawHermiteCurve();
    break;
  case 3:
    BezierCurveGrade6 curve6 = new BezierCurveGrade6(poly.points);
    curve6.drawBezierCurve();
    break;
  case 4:
    BezierCurve curve = new BezierCurve(poly.points);
    curve.drawBezierCurve(0);
    curve.drawBezierCurve(3);
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
