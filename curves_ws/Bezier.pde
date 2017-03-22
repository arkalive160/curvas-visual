class BezierCurve{
  ArrayList<ControlPoint> points;
  int SEGMENT_COUNT = 50;
  float t = 0;
  BezierCurve (ArrayList<ControlPoint> thePoints){

      this.points = thePoints;
  }

  PVector calculateBezierPoint(float t,ControlPoint p0,ControlPoint p1,ControlPoint p2,ControlPoint p3){
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

  void drawBezierCurve(int startPoint){
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

  void drawTangentLine(){
    pushStyle();
    stroke(255,0,0);
    line(points.get(2).position.x, points.get(2).position.y, points.get(4).position.x, points.get(4).position.y );
    popStyle();
  }
  void middlePoint(){

    float xm = (points.get(2).position.x + points.get(4).position.x)/2;
    float ym = (points.get(2).position.y + points.get(4).position.y)/2;
    points.get(3).position.set(xm,ym);

  }

}
