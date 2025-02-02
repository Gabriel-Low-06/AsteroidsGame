class Spaceship extends Floater {
  protected boolean follower;
  protected int hit;
  protected int health;
  Spaceship(int x, int y, boolean followee) {
    myColor = color(254, 254, 254);
    myCenterX=x;
    myCenterY=y;
    myXspeed=0;
    myYspeed=0;
    myPointDirection=-90;
    follower=followee;
    hit = 0;
    health=3;
  }
  public void move(){
    myCenterX += myXspeed;    
    myCenterY += myYspeed; 
  }

  public void show() {
    if(health>0){
    hit-=3;
    myPointDirection=myPointDirection%360;
    fill(myColor+(constrain(hit,0,100)/8));
    pushMatrix();
    translate((float)myCenterX, (float)myCenterY);
    scale(.75,.75,.75);
    if(follower==true){
      scale(.9,.9,.9);
    }
    rotate((float)myPointDirection*(3.1415/180));
    noStroke();
    quad(25, 5, 25, -5, -40, -10, -40, 10); //draw ship
    triangle(25, 5, 25, -5, 45, 0);
    triangle(10, 0, -10, 40, -10, -40); //draw ship
    triangle(-20, 0, -35, 30, -35, -30); //draw ship
    fill(1, 1, 180);
    if(follower==true){
      fill(100,100,100);
    }
    stroke(1,1,190);
    strokeWeight(5);
    translate(0,0,1);
    ellipse(25,0,20,10);
    
    if ((follower==false && keyPressed==true && keyCode==UP)||follower==true && myXspeed!=0) {
      fill(255, 0, 0);
      triangle(-40, 7, -40, -7, -57, 0); //draw fire from ship
    }
    popMatrix();
    }
  }
  
  void hyperspace(){
    fill(0,0,255);
    ellipse((float)myCenterX,(float)myCenterY,100,100);
    myCenterX=(int)(random(0,1100));
    myCenterY=(int)(random(0,700));
    myPointDirection=random(0,360);

  }
  
  void sethealth(int h){
    health = h;
  }
  int gethealth(){return health;}
  int getX() {
    return (int)myCenterX;
  }
  int getY() {
    return (int)myCenterY;
  }
   void setX(int x){
    myCenterX=x;
  }
  void setY(int y){
    myCenterY=y;
  }
  void sethit(int h){
    hit = h;
  }
  float getTheta() {
    return (float)myPointDirection;
  }
  float getV(){
    return (float)sqrt((float)(sq((float)myXspeed)+sq((float)myYspeed)));
  }

  public void follow(Spaceship leader, int xshift, int yshift) {
    float t = (leader.getTheta()*0.01745329251);
    float x1 = leader.getX()+yshift*sin(t-(float)(Math.PI/2))+(xshift*sin(t));
    float y1 = leader.getY()+yshift*-1*sin(t)+(xshift*sin(t-(float)(Math.PI/2)));
    int x = (int)myCenterX;
    int y = (int)myCenterY;
    float xoff=(x-x1)*.004;
    float yoff=(y-y1)*.004;
    float angle=atan(yoff/xoff)+(float)Math.PI;
    if (xoff<0) {
      angle-=Math.PI;
    }
    float speed = dist(x, y, x1, y1)*.001;
    if (speed>.02) {
      myPointDirection = angle*180 /Math.PI;
      accelerate(.3);
      speed=speed*15+1;
      myXspeed=constrain((float)myXspeed, -speed, speed);
      myYspeed=constrain((float)myYspeed, -speed, speed);
    } else {
      myXspeed=0;
      myYspeed=0;
      if ((abs((float)(myPointDirection-leader.getTheta())))>10) {
        if (myPointDirection>leader.getTheta()) {
          myPointDirection-=3;
        } else {
          myPointDirection+=3;
        }
        myPointDirection=myPointDirection%360;
      }
    }
  }

  public void slow() {
    myXspeed*=.94;
    myYspeed*=.94;
  }
}
