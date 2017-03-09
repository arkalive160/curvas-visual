// global variables
// modes: 0 natural cubic spline; 1 Hermite;
// 2 Catmull-Rom; 3 (degree 7) Bezier; 4 Cubic Bezier
int mode;

/*
 Completar la información para curva implementada
 
 Curva 1: <nombre>
 Implementado desde cero, adaptado o transcripción literal: Transcripción literal
 del código encontrado acá: <url> 
*/


ControlPolygon poly;
ControlPoint grabber;
boolean drawGrid = true, drawCtrl = true;

void setup() {
  size(700, 700);
  textSize(20);
  poly = new ControlPolygon(8);
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
  if (drawCtrl)
    poly.draw();
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

void mousePressed() {
  if (drawCtrl)
    for (ControlPoint p : poly.points) {
      if (grabber == null)
        if (p.grabsInput(mouseX, mouseY))
          grabber = p;
    } else
    grabber = null;
}

void mouseDragged() {
  if (grabber != null) {
    grabber.position.x = mouseX;
    grabber.position.y = mouseY;
  }
}

void mouseReleased() {
  grabber = null;
}