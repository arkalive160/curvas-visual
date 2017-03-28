import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class curves_ws extends PApplet {

// global variables
// modes: 0 natural cubic spline; 1 Hermite;
// 2 Catmull-Rom; 3 (degree 7) Bezier; 4 Cubic Bezier
int mode;

/*
 Completar la informaci\u00f3n para cada curva implementada

 Curva 1: <nombre>
 Implementado desde cero, adaptado o transcripci\u00f3n literal: Transcripci\u00f3n literal
 del c\u00f3digo encontrado ac\u00e1: <url>
*/


ControlPolygon poly;
ControlPoint grabber;
TangentPoint tangentGrabber;
ControlTangent tangents;
boolean drawGrid = true, drawCtrl = true;

public void setup() {
  
  textSize(20);
  poly = new ControlPolygon(7);
  tangents = new ControlTangent(poly.points);

  
}

public void drawGrid(float gScale) {
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

public void draw() {
  background(255, 255, 255);


  if (drawGrid)
    drawGrid(10);
  if (drawCtrl){
    poly.draw();
    //curve.drawTangentLine();
  }



  switch(mode) {
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

public void keyPressed() {
  if (key == ' ')
    mode = mode < 4 ? mode+1 : 0;
  if (key == 'g')
    drawGrid = !drawGrid;
  if (key == 'c')
    drawCtrl = !drawCtrl;
}

public void mousePressedT() {
  if (drawCtrl)
    for (TangentPoint p : tangents.tPoints) {
      if (grabber == null)
        if (p.grabsInput(mouseX, mouseY))
          tangentGrabber = p;
    } else
    tangentGrabber = null;
}

public void mousePressed() {
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

public void mouseDragged() {
  if (grabber != null) {
    grabber.position.x = mouseX;
    grabber.position.y = mouseY;
  }
  if (tangentGrabber != null) {
    tangentGrabber.position.x = mouseX;
    tangentGrabber.position.y = mouseY;
  }
}

public void mouseReleased() {
  grabber = null;
  tangentGrabber = null;
}
class BezierCurve{
  ArrayList<ControlPoint> points;
  int SEGMENT_COUNT = 50;
  float t = 0;

  BezierCurve (ArrayList<ControlPoint> thePoints){

      this.points = thePoints;
  }

  public PVector calculateBezierPoint(float t,ControlPoint p0,ControlPoint p1,ControlPoint p2,ControlPoint p3){
      float u = 1 - t;
      float tt = t*t;
      float uu = u*u;
      float uuu = uu * u;
      float ttt = tt * t;
      PVector firstTerm = PVector.mult(p0.position, uuu);
      PVector secondTerm = firstTerm.add(PVector.mult(p1.position,3*uu*t));
      PVector thirdTerm = secondTerm.add(PVector.mult(p2.position, 3*u*tt));
      PVector fourthTerm = thirdTerm.add(PVector.mult(p3.position, ttt));
      //PVector poly = PVector.add(firstTerm, PVector.add(secondTerm, PVector.add(thirdTerm,fourthTerm)));
      //println(fourthTerm);
      return fourthTerm;

  }

  public void drawBezierCurve(int startPoint){
    middlePoint();
    PVector q0 = calculateBezierPoint(0, points.get(startPoint), points.get(startPoint+1), points.get(startPoint+2), points.get(startPoint+3));
    int i;
    for(i = 0; i <= SEGMENT_COUNT; i++ ){
      float t = i / (float) SEGMENT_COUNT;
      PVector q1 = calculateBezierPoint(t, points.get(startPoint), points.get(startPoint+1), points.get(startPoint+2), points.get(startPoint+3));
      stroke(0);
      strokeWeight(4);
      line(q0.x, q0.y, q1.x, q1.y);
      q0=q1;

    }
  }

  public void drawTangentLine(){
    pushStyle();
    stroke(255,0,0);
    line(points.get(2).position.x, points.get(2).position.y, points.get(4).position.x, points.get(4).position.y );
    popStyle();
  }
  public void middlePoint(){

    float xm = (points.get(2).position.x + points.get(4).position.x)/2;
    float ym = (points.get(2).position.y + points.get(4).position.y)/2;
    points.get(3).position.set(xm,ym);

  }

}
class BezierCurveGrade6{
  ArrayList<ControlPoint> points;
  int SEGMENT_COUNT = 50;
  float t = 0;

  BezierCurveGrade6 (ArrayList<ControlPoint> thePoints){
      this.points = thePoints;
  }

  public PVector calculateBezierPoint(float t){
      float u = 1 - t;
      PVector firstTerm = PVector.mult(points.get(0).position, pow(u,6) );
      PVector secondTerm = firstTerm.add(PVector.mult(points.get(1).position, 6 * t * pow(u,5) ));
      PVector thirdTerm = secondTerm.add(PVector.mult(points.get(2).position, 15 * pow(t,2) * pow(u,4) ));
      PVector fourthTerm = thirdTerm.add(PVector.mult(points.get(3).position, 20 * pow(t,3) * pow(u,3) ));

      PVector fifthT = fourthTerm.add(PVector.mult(points.get(4).position, 15* pow(t,4) * pow(u,2) ));

      PVector sixth = fifthT.add (PVector.mult(points.get(5).position, 6 * pow(t,5) * u ));

      PVector seventh = sixth.add( PVector.mult(points.get(6).position, pow(t,6) ));

      return seventh;

  }

  public void drawBezierCurve(){
    //middlePoint();
    PVector q0 = calculateBezierPoint(0);
    int i;
    for(i = 0; i <= SEGMENT_COUNT; i++ ){
      float t = i / (float) SEGMENT_COUNT;
      PVector q1 = calculateBezierPoint(t);
      stroke(0);
      strokeWeight(4);
      line(q0.x, q0.y, q1.x, q1.y);
      q0=q1;

    }
  }

  public void drawTangentLine(){
    pushStyle();
    stroke(255,0,0);
    line(points.get(2).position.x, points.get(2).position.y, points.get(4).position.x, points.get(4).position.y );
    popStyle();
  }
  public void middlePoint(){

    float xm = (points.get(2).position.x + points.get(4).position.x)/2;
    float ym = (points.get(2).position.y + points.get(4).position.y)/2;
    points.get(3).position.set(xm,ym);

  }

}
class Catmull {

ArrayList<ControlPoint> cPoints;
ArrayList<TangentPoint> tPoints;
int SEGMENT_COUNT = 50;
float t = 0;

  Catmull (ArrayList<ControlPoint> cPoints, ArrayList<TangentPoint> tPoints){
      this.tPoints = tPoints;
      this.cPoints = cPoints;
  }

  public PVector calculateHermitePoint(float t,PVector p0, PVector p1, PVector m0, PVector m1){
      float u = 1 - t;

      PVector firstTerm = PVector.mult( p0, 2*pow(t,3) - 3*pow(t,2) + 1);
      PVector secondTerm = firstTerm.add(PVector.mult( p1, -2*pow(t,3) + 3*pow(t,2) ));
      PVector thirdTerm = secondTerm.add(PVector.mult( m0, pow(t,3) - 2*pow(t,2) + t ));
      PVector fourthTerm = thirdTerm.add(PVector.mult( m1, pow(t,3) - pow(t,2) ));
      return fourthTerm;

  }

  public void drawCatmullCurve(){



    for(int i=0; i < cPoints.size() -1; i++){

      PVector current = cPoints.get(i).position;
      PVector next = cPoints.get(i+1).position;
      PVector tangent_current = i == 0? current :
      PVector.mult( PVector.sub(next, cPoints.get(i-1).position), 0.5f );
      //  PVector tangent_next = PVector.mult( PVector.sub( cPoints.get(i+2).position, current ), 0.5 );
      PVector tangent_next = i == cPoints.size()-2? next:
      PVector.mult( PVector.sub( cPoints.get(i+2).position, current ), 0.5f ) ;




        PVector q0 = calculateHermitePoint(0, current, next, tangent_current, tangent_next);
        int stepts;
        for(stepts = 0; stepts<= SEGMENT_COUNT; stepts++ ){
          float t = stepts / (float) SEGMENT_COUNT;
          PVector q1 = calculateHermitePoint(t, current, next,  tangent_current, tangent_next);
          stroke(0);
          strokeWeight(4);
          line(q0.x, q0.y, q1.x, q1.y);
          q0=q1;

        }
    }


  }


}
class ControlPoint {
  float radiusX = 20, radiusY = 20;
  PVector position;

  ControlPoint() {
    position = new PVector(random(radiusX, width-radiusX), random(radiusY, height-radiusY));
  }

  ControlPoint(int x, int y) {
    position = new PVector(x, y);
  }

  public boolean grabsInput(float x, float y) {
    return(pow((x - position.x), 2)/pow(radiusX, 2) + pow((y - position.y), 2)/pow(radiusY, 2) <= 1);
  }

  public void draw() {
    pushStyle();
    strokeWeight(2);
    fill(grabsInput(mouseX, mouseY) ? 255 : 0, 0, 255, 125);
    ellipse(position.x, position.y, 2*radiusX, 2*radiusY);
    popStyle();
  }
}

class ControlPolygon {
  ArrayList<ControlPoint> points;

  ControlPolygon() {
    points = new ArrayList<ControlPoint>();
  }

  ControlPolygon(int size) {
    points = new ArrayList<ControlPoint>();
    for (int i=0; i<size; i++)
      points.add(new ControlPoint());
  }

  public void draw() {
    pushStyle();
    ControlPoint previous = null;
    stroke(0, 255, 0);
    strokeWeight(3);
    for (int index = 0; index < points.size(); index++) {
      ControlPoint current = points.get(index);
      current.draw();
      fill(255,255,0);
      text(Integer.toString(index), current.position.x, current.position.y);
      if (previous != null)
        line(previous.position.x, previous.position.y, current.position.x, current.position.y);
      previous = current;
    }
    popStyle();
  }
}

class TangentPoint {
  float radiusX = 10, radiusY = 10;
  PVector position;
  PVector tangent;

  TangentPoint() {
    position = new PVector(random(radiusX, width-radiusX), random(radiusY, height-radiusY));
  }

  TangentPoint(int x, int y) {
    position = new PVector(x, y);
  }

  public boolean grabsInput(float x, float y) {
    return(pow((x - position.x), 2)/pow(radiusX, 2) + pow((y - position.y), 2)/pow(radiusY, 2) <= 1);
  }

  public void draw() {
    pushStyle();
    strokeWeight(2);
    fill(grabsInput(mouseX, mouseY) ? 255 : 255, 0, 0, 125);
    ellipse(position.x, position.y, 2*radiusX, 2*radiusY);
    popStyle();
  }
}

class ControlTangent {
  ArrayList<TangentPoint> tPoints;
  ArrayList<ControlPoint> cPoints;

  ControlTangent(ArrayList<ControlPoint> points) {

    tPoints = new ArrayList<TangentPoint>();
    cPoints = points;
    for (int i=0; i< points.size(); i++){
      tPoints.add(new TangentPoint());
      ControlPoint control_current = cPoints.get(i);
      TangentPoint tanget_current = tPoints.get(i);

    }


  }

  public void draw() {
    pushStyle();
    for (int i=0; i< tPoints.size(); i++){
      ControlPoint control_current = cPoints.get(i);
      TangentPoint tanget_current = tPoints.get(i);
      tanget_current.draw();
      fill(255,0,0);

      stroke(255, 153, 250);
      line(control_current.position.x,control_current.position.y,tanget_current.position.x,tanget_current.position.y);

    }

    popStyle();
  }
}
class HermiteCurve {

ArrayList<ControlPoint> cPoints;
ArrayList<TangentPoint> tPoints;
int SEGMENT_COUNT = 50;
float t = 0;

  HermiteCurve (ArrayList<ControlPoint> cPoints, ArrayList<TangentPoint> tPoints){
      this.tPoints = tPoints;
      this.cPoints = cPoints;
  }

  public PVector calculateHermitePoint(float t,PVector p0, PVector p1, PVector m0, PVector m1){
      float u = 1 - t;

      PVector firstTerm = PVector.mult( p0, 2*pow(t,3) - 3*pow(t,2) + 1);
      PVector secondTerm = firstTerm.add(PVector.mult( p1, -2*pow(t,3) + 3*pow(t,2) ));
      PVector thirdTerm = secondTerm.add(PVector.mult( m0, pow(t,3) - 2*pow(t,2) + t ));
      PVector fourthTerm = thirdTerm.add(PVector.mult( m1, pow(t,3) - pow(t,2) ));
      return fourthTerm;

  }

  public void drawHermiteCurve(){



    for(int i=0; i < cPoints.size() -1; i++){

      PVector current = cPoints.get(i).position;
      PVector next = cPoints.get(i+1).position;
      PVector tangent_current = PVector.sub(tPoints.get(i).position, current );
      PVector tangent_next = PVector.sub(tPoints.get(i+1).position, next );

        PVector q0 = calculateHermitePoint(0, current, next, tangent_current, tangent_next);
        int stepts;
        for(stepts = 0; stepts<= SEGMENT_COUNT; stepts++ ){
          float t = stepts / (float) SEGMENT_COUNT;
          PVector q1 = calculateHermitePoint(t, current, next,  tangent_current, tangent_next);
          stroke(0);
          strokeWeight(4);
          line(q0.x, q0.y, q1.x, q1.y);
          q0=q1;

        }
    }


  }

  public PVector tangentVector(PVector control, PVector tangent){
    return control.add( tangent.mult(-1) );
  }


}
/*
Codigo original tomado de : http://introcs.cs.princeton.edu/java/95linear/Matrix.java.html
Copyright \u00a9 2000\u20132011, Robert Sedgewick and Kevin Wayne.
Last updated: Tue Aug 30 09:58:33 EDT 2016.
*/


/******************************************************************************
 *  Compilation:  javac Matrix.java
 *  Execution:    java Matrix
 *
 *  A bare-bones immutable data type for M-by-N matrices.
 *
 ******************************************************************************/

class Matrix {

    int M;             // number of rows
    int N;             // number of columns
    float[][] data;   // M-by-N array



    // create M-by-N matrix of 0's
    public Matrix(int M, int N) {
        this.M = M;
        this.N = N;
        data = new float[M][N];
    }

    // create matrix based on 2d array
    public Matrix(float[][] data) {
        M = data.length;
        N = data[0].length;
        this.data = new float[M][N];
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                    this.data[i][j] = data[i][j];
    }

    // copy constructor
    private Matrix(Matrix A) { this(A.data); }

    // swap rows i and j
    private void swap(int i, int j) {
        float[] temp = data[i];
        data[i] = data[j];
        data[j] = temp;
    }

    // create and return the transpose of the invoking matrix
    public Matrix transpose() {
        Matrix A = new Matrix(N, M);
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                A.data[j][i] = this.data[i][j];
        return A;
    }

    // return C = A + B
    public Matrix plus(Matrix B) {
        Matrix A = this;
        if (B.M != A.M || B.N != A.N) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(M, N);
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                C.data[i][j] = A.data[i][j] + B.data[i][j];
        return C;
    }


    // return C = A - B
    public Matrix minus(Matrix B) {
        Matrix A = this;
        if (B.M != A.M || B.N != A.N) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(M, N);
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                C.data[i][j] = A.data[i][j] - B.data[i][j];
        return C;
    }

    // does A = B exactly?
    public boolean eq(Matrix B) {
        Matrix A = this;
        if (B.M != A.M || B.N != A.N) throw new RuntimeException("Illegal matrix dimensions.");
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                if (A.data[i][j] != B.data[i][j]) return false;
        return true;
    }

    // return C = A * B
    public Matrix times(Matrix B) {
        Matrix A = this;
        if (A.N != B.M) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(A.M, B.N);
        for (int i = 0; i < C.M; i++)
            for (int j = 0; j < C.N; j++)
                for (int k = 0; k < A.N; k++)
                    C.data[i][j] += (A.data[i][k] * B.data[k][j]);
        return C;
    }


    // return x = A^-1 b, assuming A is square and has full rank
    public Matrix solve(Matrix rhs) {
        if (M != N || rhs.M != N || rhs.N != 1)
            throw new RuntimeException("Illegal matrix dimensions.");

        // create copies of the data
        Matrix A = new Matrix(this);
        Matrix b = new Matrix(rhs);

        // Gaussian elimination with partial pivoting
        for (int i = 0; i < N; i++) {

            // find pivot row and swap
            int max = i;
            for (int j = i + 1; j < N; j++)
                if (Math.abs(A.data[j][i]) > Math.abs(A.data[max][i]))
                    max = j;
            A.swap(i, max);
            b.swap(i, max);

            // singular
            if (A.data[i][i] == 0.0f) throw new RuntimeException("Matrix is singular.");

            // pivot within b
            for (int j = i + 1; j < N; j++)
                b.data[j][0] -= b.data[i][0] * A.data[j][i] / A.data[i][i];

            // pivot within A
            for (int j = i + 1; j < N; j++) {
                double m = A.data[j][i] / A.data[i][i];
                for (int k = i+1; k < N; k++) {
                    A.data[j][k] -= A.data[i][k] * m;
                }
                A.data[j][i] = 0.0f;
            }
        }

        // back substitution
        Matrix x = new Matrix(N, 1);
        for (int j = N - 1; j >= 0; j--) {
            float t = 0.0f;
            for (int k = j + 1; k < N; k++)
                t += A.data[j][k] * x.data[k][0];
            x.data[j][0] = (b.data[j][0] - t) / A.data[j][j];
        }
        return x;
    }

}
  public void settings() {  size(700, 700);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "curves_ws" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
