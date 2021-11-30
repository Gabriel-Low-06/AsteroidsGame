class Asteroid extends BaseObj {
  protected int exstatus;
  protected int shade;
  protected float config[];
  protected boolean hityet;
  Asteroid() {
    setrandomly();
    shade=(int)(random(50, 200)); //give asteroid random color, setup, rotation
    float[] loadcon = {(int)(random(0, 30)), (int)(random(0, 30)), (int)(random(25, 75))};
    config=loadcon;
    exstatus=0;
    hityet = false;
  }
  void show() {
    strokeWeight(1);
    stroke(0,0,0);
    if (loc[0]>1150||loc[0]<-50||loc[1]>750||loc[1]<-50) { //portal through outside edges
      loc[0]=(550-loc[0])+ 550;
      loc[1]=(350-loc[1]) + 350;
    }
    fill(shade-(exstatus/3), shade-exstatus, shade-exstatus);
    sphereDetail(7); //control resolution of asteroid
    sphere(20); //draw asteroid
    translate(config[0], config[1], 0);
    sphere(config[2]/2);
    if (exstatus>0 && exstatus<180) {
        noFill();
        strokeWeight(4);
        stroke(255, 255, 255);
        ellipse(-(config[0]/2), -(config[1]/2), exstatus, exstatus);
      }
      if(dist(loc[0],loc[1],Jeremiah.getX(),Jeremiah.getY())<60 && hityet==false){ // if laser hits ship, lower health
      myhealth-=5;
      hityet = true;
      Jeremiah.sethit(50);
    }else if(dist(loc[0],loc[1],Jeremiah.getX(),Jeremiah.getY())>60 && hityet==true){
      hityet=false;
    }
  }
  int getExstatus() {
    return exstatus;
  }
  void setExstatus(int set) {
    exstatus=set;
  }
  
  void explode() { //if exploded, blast composite asteroids apart
    config[0]+=4;
    config[1]+=4;
    exstatus+=4;
    
  }
}

class Enemy extends BaseObj {
  int exstatus;
  Enemy() {
    setrandomly();
    exstatus=0;
    for(int i=0; i<3; i++){vel[i]=0;}
  }
  void show() {
    if(exstatus<200){
    noStroke();
    sphereDetail(15); //if initialized as Enemy, draw Enemey
    fill(255, 00, 0);
    sphere(20);
    sphereDetail(12);
    fill(100, 100, 100);
    scale(1, .2, 1);
    sphere(40);
    if (exstatus>0) {
      fill(255, 0, 0);
      sphere(exstatus/1.5);
    }
    }
  }

  void extrastuff(int value) {
    float xshift=(Jeremiah.getX()-loc[0])*.002;
    float yshift=(Jeremiah.getY()-loc[1])*.002;
    float angle=atan(yshift/xshift);
    if (xshift<0) {
      angle+=3.1415;
    }
    if (dist(loc[0], loc[1], Jeremiah.getX(), Jeremiah.getY())>300) { //if far away from ship, move closer
      vel[0]+=xshift;
      vel[1]+=yshift;
    } else if (dist(loc[0], loc[1], Jeremiah.getX(), Jeremiah.getY())<100) { //if too close, retreat
      vel[0]-= .6-xshift;
      vel[1]-= .6-yshift;
    }
    if (millis()%300<5) { //occasionally, fire lasers at ship
      blasts[Lasercount]=new Lasers(value, angle);
      realLasercount=(constrain(realLasercount+1, 0, 40));
      Lasercount+=1;
      if (Lasercount>39) {
        Lasercount=0;
      }
    }
    for(int i=0; i<3; i++){vel[i]=constrain(vel[i],-3,3);}
  }
  void explode() { //if exploded, blast composite asteroids apart
    exstatus+=4;
  }
  
  int getExstatus(){
    return exstatus;
  }
  void setExstatus(int ex){
    exstatus=ex;
  }
}
