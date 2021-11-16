int complexity=25;
int Lasercount=0; //how many lasers to display
int realLasercount=0;
int myhealth = 100; //health of ship

Celestial[] systems = new Celestial[complexity];
BaseObj[] rocks = new BaseObj[15]; //declare all elements
Stars[] streaks = new Stars[30];
Lasers[]blasts=new Lasers[40];
Spaceship Jeremiah =new Spaceship(550,40, false);
Spaceship[] Fleet = new Spaceship[6];

void setup() {
  size(1100, 700, P3D);
  for (int i=0; i<30; i++) { //initialize all elements
    streaks[i] = new Stars();
  }
  for (int q=0; q<15; q++) {
    if (q<13) {
      rocks[q]=new Asteroid();
    } else {
      rocks[q]=new Enemy();
    }
  }
  for (int i=0; i<complexity; i++) {
    systems[i]=new Celestial(i);
  }
  for(int i=0; i<6; i++){
    Fleet[i]=new Spaceship((i%3)*100+250,((i/3)+1)*100+50, true);
  }
}

void draw() {
background(0,0,0);
  pushMatrix();
  translate(-4550, -2900, -5000); //move stars and background behind asteroid
  scale(9.3, 9.3);
  //fill(0, 0, 0, 140); //create blurred effect while refreshing frame
  //noStroke();
  //rect(0, 0, 1100, 700);
  for (int i=0; i<30; i++) { //draw stars
    streaks[i].paint();
  }
  scale(7,7);
  translate(-550,-350,1);
  for (int i=0; i<complexity; i++) { //draw planets in background
    systems[i].gravity(i);
    systems[i].move();
    systems[i].show();
  }
  popMatrix();

  for (int q=0; q<15; q++) {    
    if (rocks[q].getExstatus()>0) { //if hit, explode asteroids
      rocks[q].explode();
    }
    if (rocks[q].getExstatus()<200) {
       rocks[q].render(); //draw asteroids and enemy ships
      rocks[q].extrastuff(q); //steer enemy ship
    }
  }
  if (keyPressed) {
    if (keyCode==RIGHT) { //controls movement of ship
      Jeremiah.turn(3);  
    }
    if (keyCode==LEFT) {
      Jeremiah.turn(-3);  
    }
    if (keyCode==UP) {
      Jeremiah.accelerate(.1); 
    }
    if (keyCode==ENTER) { //teleports ship to new location
    }
    if (keyCode==DOWN) { //fires lasers
      blasts[Lasercount]=new Lasers();
      realLasercount=(constrain(realLasercount+1,0,40));
      Lasercount+=1;
      if (Lasercount>39) {
        Lasercount=0;
      }
      for(int i=0; i<6;i++){
      blasts[Lasercount]=new Lasers(Fleet[i]);
      realLasercount=(constrain(realLasercount+1,0,40));
      Lasercount+=1;
      if (Lasercount>39) {
        Lasercount=0;
      }
      }
      keyCode=0;
    }
  } else {
    Jeremiah.slow();
  }
  
   Jeremiah.show(); 
  Jeremiah.move();  
  for(int i=0; i<6; i++){
    Fleet[i].show();
    Fleet[i].follow(Jeremiah,(int)(((i+2)%2*100*((i+2)/2))-(50*((i+2)/2))),((i/2)+1)*80);
     Fleet[i].move();

  }

  for (int z=0; z<realLasercount; z++) { //draw lasers
    blasts[z].show();
    blasts[z].scan();
  }
  fill(300,300,300);  
  strokeWeight(0);
  rect(890,30,100,20);
  fill(300,0,0);
  rect(890,30,(int)myhealth,20);
  textSize(30);
  text(myhealth, 1020, 35); //display health
}

class BaseObj {
  protected float[] loc;
  protected float[] vel;
  protected float[] rot;
  protected float[] tor;

  void render() {
    pushMatrix();
    translate(loc[0],loc[1],loc[2]);
    rotateX(rot[0]);rotateY(rot[1]);rotateZ(rot[2]);
    for(int i=0; i<3; i++){
      loc[i]+=vel[i]; rot[i]+=tor[i]; 
    }
    show();
    popMatrix();
  }
  
  public void setrandomly(){
    float[] locset = {random(0,1100),random(0,700),random(0,-500)}; loc=locset;
    float[] velset = {random(-1,1),random(-1,1),random(-1,1)}; vel=velset;
    float[] rotset = {random(-8,8),random(-8,8),random(-8,8)}; rot=rotset;
    float[] torset = {random(-.01,.01),random(-.01,.01),random(-.01,.01)}; tor=torset;
  }
  
  void show(){
  }
  
  float[] getLoc(){return loc;}
  float[] getVel(){return vel;}
  float[] getRot(){return rot;}
  float[] getTor(){return tor;}
  void setLoc(float[] l){loc=l;}
  void setVel(float[] v){vel=v;}
  void setRot(float[] r){rot=r;}
  void setTor(float[] t){tor=t;}
  void setExstatus(int something){}
  int getExstatus(){return 1;}
  
  void extrastuff(int value){
  }
  void explode(){}
}


class Asteroid extends BaseObj {
  protected int exstatus;
  protected int shade;
  protected float config[];
  Asteroid() {
    setrandomly();
    shade=(int)(random(50, 200)); //give asteroid random color, setup, rotation
    float[] loadcon = {(int)(random(0, 30)), (int)(random(0, 30)), (int)(random(25, 75))};
    config=loadcon;
    exstatus=0;
  }
  void show() {
    noStroke();
    if (loc[0]>1150||loc[0]<-50||loc[1]>750||loc[1]<-50) { //portal through outside edges
      loc[0]=(550-loc[0])+ 550;
      loc[1]=(350-loc[1]) + 350;
    }
    fill(shade, shade, shade);
    sphereDetail(7); //control resolution of asteroid
    sphere(20); //draw asteroid
    translate(config[0], config[1], 0);
    sphere(config[2]/2);
    if (exstatus>0) {
        noFill();
        strokeWeight(4);
        stroke(255, 255, 255);
        ellipse(-(config[0]/2), -(config[1]/2), exstatus, exstatus);
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

  void extrastuff(int value) {
    float xshift=(Jeremiah.getX()-loc[0])*.004;
    float yshift=(Jeremiah.getY()-loc[1])*.004;
    float angle=atan(yshift/xshift);
    if (xshift<0) {
      angle+=3.1415;
    }
    if (dist(loc[0], loc[1], Jeremiah.getX(), Jeremiah.getY())>300) { //if far away from ship, move closer
      vel[0]+=xshift;
      vel[1]+=yshift;
    } else if (dist(loc[0], loc[1], Jeremiah.getX(), Jeremiah.getY())<100) { //if too close, retreat
      vel[0]-= 1-xshift;
      vel[1]-= 1-yshift;
    }
    if (millis()%600<5) { //occasionally, fire lasers at ship
      blasts[Lasercount]=new Lasers(value, angle);
      realLasercount=(constrain(realLasercount+1, 0, 40));
      Lasercount+=1;
      if (Lasercount>39) {
        Lasercount=0;
      }
    }
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

float speediness=.01;

class Celestial {
  private int s, tint, independent;
  private float xvelocity, yvelocity, mass, x, y;
  Celestial(int value) {
    independent=72;
    mass=random(.5, 1);
    s=(int)(mass*4);
    tint = color((int)(random(0, 155)), (int)(random(0, 155)), (int)(random(0, 155)));
    
    if(value<complexity-3){
    float radius=random(100,400);
    float theta=random(0,7);
    x=(int)((cos(theta)*radius)+550);
    y=(int)((sin(theta)*radius)+350);
    theta+=3.14159/2;
    yvelocity=sin(theta)*(sqrt(speediness*4000/radius))*random(.8,1.2);
    xvelocity=cos(theta)*(sqrt(speediness*4000/radius));
    }
    else if (value>complexity-2) {
      mass=4000;
      x=550; 
      y=350;
      s=25;
      tint=color(255, 150, 50);
      xvelocity=0;
      yvelocity=0;
    }else{
      x=(int)(random(100,1000));
      y=(int)(random(100,700));
      xvelocity=random(-3,3);
      yvelocity=random(-3,3);
    }
    
  }
  void move() {
    if (independent>50 && mass<800) {
      x+=xvelocity;
      y+=yvelocity;
      //x=constrain(x, 0, 1100);
      //y=constrain(y, 0, 700);
    } else if (independent<50) {
      x=systems[independent].x;
      y=systems[independent].y;
    }
  }
  void show() {
    noStroke();   
    fill(tint);
    ellipse(x, y, s, s);
    if(mass>200){
      PImage Sun = loadImage("Psun.png");
      fill(255,255,0,100);
      ellipse(x,y,s+18,s+18);
      //fill(255, 100, 50,100);
      //ellipse(x,y,s+22,s+22);
      image(Sun,x-20,y-20,40,40);
      
      //fill(255, 150, 50,150);
      //ellipse(x,y,s+8,s+8);
    }
  }
  void gravity(int value) {
    for (int i=0; i<complexity; i++) {
      if (i!=value && independent>40) {
        float distance = sq(dist(systems[i].x, systems[i].y, x, y));
        float force=0;
        float theta=0;
        if (distance>systems[i].s && distance!=0) {
          force = systems[i].mass*speediness/distance;
          theta = atan((systems[i].y-y)/(systems[i].x-x));
          if (x>systems[i].x) {
            theta+=3.1415;
          }
        } else if (independent>50) {
          if (mass>systems[i].mass) {
            systems[i].independent=value;
          } else {
            independent=i;
          }
        }
        xvelocity+=force*cos(theta);
        yvelocity+=force*sin(theta);
      }
    }
  }
}

class Lasers extends Stars{
  private float velocity, theta;
  Lasers(){ //constructor for good guy lasers
    velocity=Jeremiah.getV()+10;
    theta=Jeremiah.getTheta()*(float)Math.PI/180;
    x=Jeremiah.getX()+(cos(theta)*20);
    y=Jeremiah.getY()+(sin(theta)*20);
    mycolor=color(0,0,255);
    s=10;
  }
  Lasers(Spaceship take){ //constructor for backup fleet
    velocity=Jeremiah.getV()+10;
    theta=take.getTheta()*(float)Math.PI/180;
    x=take.getX()+(cos(theta)*20);
    y=take.getY()+(sin(theta)*20);
    mycolor=color(0,0,255);
    s=6;
    
  }
  Lasers(int sender, float angle){ //constructor for enemy lasers
    x=rocks[sender].loc[0];
   y=rocks[sender].loc[1];
   velocity=10;
   mycolor=color(200,0,0);
   theta=angle;
   s=10;
    
  }
  void show(){ //display lasers
    fill(mycolor);
    ellipse(x,y,s,s);
    x+=cos(theta)*velocity;
    y+=sin(theta)*velocity;
  }
  
  void scan(){
    for(int i=0; i<15; i++){ //check to see if laser hit asteroid, if so, tell asteroid to blow up
      int x1 = (int)rocks[i].getLoc()[0];
      int y1 = (int)rocks[i].getLoc()[1];
      if(dist(x,y,x1,y1)<50 &&rocks[i].getExstatus()==0 &&(i<13||mycolor!=color(200,0,0))){
        rocks[i].setExstatus(1);
        x=1200;
        velocity=0;
      }
    }
    if(dist(x,y,Jeremiah.getX(),Jeremiah.getY())<20){ // if laser hits ship, lower health
      myhealth-=1;
      x=1200;
      velocity=0;
    }
    
  }
  
}
