class NaturalCubic {

ArrayList<ControlPoint> cPoints;
ArrayList<ControlPoint> aux;
int SEGMENT_COUNT = 50;
float t = 0;

float[][] A1={{2,1,1,1,1,1,1},
           {1,4,1,1,1,1,1},
           {1,1,4,1,1,1,1},
           {1,1,1,4,1,1,1},
           {1,1,1,1,4,1,1},
           {1,1,1,1,1,4,1},
           {1,1,1,1,1,1,2}};
float[][] Bx = new float[7][1];
float[][] By = new float[7][1];
float[][] Dx = new float[7][1];
float[][] Dy = new float[7][1];

PVector[] a = new PVector [7];
PVector[] b = new PVector [7];
PVector[] c = new PVector [7];
PVector[] d = new PVector [7];

  NaturalCubic (ArrayList<ControlPoint> cPoints, ArrayList<ControlPoint> aux){
      this.cPoints = cPoints;
      this.aux = aux;
  }
  
  void calculateCoefficients(float[][] mdx, float[][] mdy){
    
    
    for(int i=0; i < cPoints.size(); i++){
      aux.get(i).position.set(mdx[i][0], mdy[i][0]);     
      //aux.get(i+1).position.set(mdx[i+1][0], mdy[i+1][0]);
      a[i]=cPoints.get(i).position;
      b[i]=aux.get(i).position;
       
    }
    
    
    for(int i=0; i < cPoints.size()-1; i++){
      aux.get(i).position.set(mdx[i][0], mdy[i][0]);     
      aux.get(i+1).position.set(mdx[i+1][0], mdy[i+1][0]);      
      c[i]=PVector.sub(PVector.sub(PVector.mult(PVector.sub(cPoints.get(i+1).position, cPoints.get(i).position),3), PVector.mult(aux.get(i).position,2)), aux.get(i+1).position);
      d[i]=PVector.add(PVector.add(PVector.mult(PVector.sub(cPoints.get(i).position, cPoints.get(i+1).position),2), aux.get(i).position), aux.get(i+1).position);
        
    }
    
    //COEFFICIENTS
      //for(int i=0; i<7; i++){
        
      //  print(a[i],"\n", b[i],"\n", c[i],"\n", d[i],"\n",);  
      //}
  
  }
  
  void calculateDerivates(){
    float cX=0, cY=0;
    Matrix A = new Matrix(A1);   
    
    for(int i=0; i < cPoints.size()-1; i++){
       
      //PVector current = cPoints.get(i).position;
      PVector next = cPoints.get(i+1).position;             
      if(i < 2){
        cX = PVector.mult(PVector.sub(next,cPoints.get(0).position),3).x;
        cY = PVector.mult(PVector.sub(next,cPoints.get(0).position),3).y;
      }
      if(i > cPoints.size()-3){
        cX = PVector.mult(PVector.sub(cPoints.get(6).position, cPoints.get(i-1).position),3).x;
        cY = PVector.mult(PVector.sub(cPoints.get(6).position, cPoints.get(i-1).position),3).y;
      
      }
      
      if(i> 1 && i < cPoints.size()-2){
        cX = PVector.mult(PVector.sub(next,cPoints.get(i-1).position),3).x;
        cY = PVector.mult(PVector.sub(next,cPoints.get(i-1).position),3).y;      
      }      
      
      Bx[i][0]= cX;
      By[i][0]= cY;
    }
      Matrix B1 = new Matrix(Bx);
      Matrix B2 = new Matrix(By);
      
      Dx=A.solve(B1).data;
      Dy=A.solve(B2).data; 
      calculateCoefficients(Dx,Dy);
      //DERIVADAS
      //for(int i=0; i<7; i++){
      //  for(int j=0; j<1; j++){
        
      //  print("(",Dx[i][j],",",Dy[i][j],")\n");
        
      //  }    
      //}
      drawNaturalCurve();
  }
  
  void drawNaturalCurve(/*boolean catmull*/){

    for(int i=0; i < cPoints.size() -1; i++){
    
        PVector q0 = PVector.add(PVector.add(PVector.add(a[i],PVector.mult(b[i],pow(0,1))), PVector.mult(c[i],pow(0,2))),PVector.mult(d[i],pow(0,3)));
        int stepts;
        for(stepts = 0; stepts<= SEGMENT_COUNT; stepts++ ){
          float t = stepts / (float) SEGMENT_COUNT;
          PVector q1 = PVector.add(PVector.add(PVector.add(a[i],PVector.mult(b[i],t)), PVector.mult(c[i],pow(t,2))),PVector.mult(d[i],pow(t,3)));
          stroke(0);
          strokeWeight(4);
          line(q0.x, q0.y, q1.x, q1.y);
          q0=q1;

        }
      }
    }
  
  
  
  
}