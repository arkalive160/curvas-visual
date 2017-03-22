class HermiteCurve {

ArrayList<ControlPoint> cPoints;
ArrayList<TangentPoint> tPoints;
int SEGMENT_COUNT = 50;
float t = 0;

  HermiteCurve (ArrayList<ControlPoint> cPoints, ArrayList<TangentPoint> tPoints){
      this.tPoints = tPoints;
      this.cPoints = cPoints;
  }

  PVector calculateHermitePoint(float t,ControlPoint p0,ControlPoint p1, TangentPoint m0, TangentPoint m1){
      float u = 1 - t;

      PVector firstTerm = PVector.mult( p0.position, 2*pow(t,3) - 3*pow(t,2) + 1);
      PVector secondTerm = firstTerm.add(PVector.mult( p1.position, -2*pow(t,3) + 3*pow(t,2) ));
      PVector thirdTerm = secondTerm.add(PVector.mult( m0.position, pow(t,3) - 2*pow(t,2) + t ));
      PVector fourthTerm = thirdTerm.add(PVector.mult( m1.position, pow(t,3) - pow(t,2) ));
      return fourthTerm;

  }

  void drawHermiteCurve(){
    //middlePoint();
    PVector q0 = calculateHermitePoint(0,  cPoints.get(0), cPoints.get(1), tPoints.get(0), tPoints.get(1));
    int i;
    for(i = 0; i <= SEGMENT_COUNT; i++ ){
      float t = i / (float) SEGMENT_COUNT;
      PVector q1 = calculateHermitePoint(t, cPoints.get(0), cPoints.get(1), tPoints.get(0), tPoints.get(1));
      stroke(0);
      strokeWeight(4);
      line(q0.x, q0.y, q1.x, q1.y);
      q0=q1;

    }
  }


}
