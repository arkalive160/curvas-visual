class BezierCurveGrade6{
  ArrayList<ControlPoint> points;
  int SEGMENT_COUNT = 50;
  float t = 0;

  BezierCurveGrade6 (ArrayList<ControlPoint> thePoints){
      this.points = thePoints;
  }

  PVector calculateBezierPoint(float t){
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

  void drawBezierCurve(){
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
