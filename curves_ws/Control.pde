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

  void draw() {
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

  void draw() {
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

  void draw() {
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

  void draw() {
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
