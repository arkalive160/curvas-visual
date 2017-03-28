class Catmull {

ArrayList<ControlPoint> cPoints;
ArrayList<TangentPoint> tPoints;
int SEGMENT_COUNT = 50;
float t = 0;

  Catmull (ArrayList<ControlPoint> cPoints, ArrayList<TangentPoint> tPoints){
      this.tPoints = tPoints;
      this.cPoints = cPoints;
  }

  PVector calculateHermitePoint(float t,PVector p0, PVector p1, PVector m0, PVector m1){
      float u = 1 - t;

      PVector firstTerm = PVector.mult( p0, 2*pow(t,3) - 3*pow(t,2) + 1);
      PVector secondTerm = firstTerm.add(PVector.mult( p1, -2*pow(t,3) + 3*pow(t,2) ));
      PVector thirdTerm = secondTerm.add(PVector.mult( m0, pow(t,3) - 2*pow(t,2) + t ));
      PVector fourthTerm = thirdTerm.add(PVector.mult( m1, pow(t,3) - pow(t,2) ));
      return fourthTerm;

  }

  void drawCatmullCurve(){



    for(int i=0; i < cPoints.size() -1; i++){

      PVector current = cPoints.get(i).position;
      PVector next = cPoints.get(i+1).position;
      PVector tangent_current = i == 0? current :
      PVector.mult( PVector.sub(next, cPoints.get(i-1).position), 0.5 );
      //  PVector tangent_next = PVector.mult( PVector.sub( cPoints.get(i+2).position, current ), 0.5 );
      PVector tangent_next = i == cPoints.size()-2? next:
      PVector.mult( PVector.sub( cPoints.get(i+2).position, current ), 0.5 ) ;




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
