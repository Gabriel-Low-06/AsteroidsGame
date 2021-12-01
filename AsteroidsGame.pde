static int complexity=25;
int myhealth = 100; //health of ship
boolean playing=true;
int timer=0;

Celestial[] systems = new Celestial[complexity];
ArrayList<BaseObj> rocks = new ArrayList<BaseObj>(); //declare all elements
Stars[] streaks = new Stars[30];
ArrayList <Lasers>blasts = new ArrayList<Lasers>();
Spaceship Jeremiah =new Spaceship(550, 40, false);
Spaceship[] Fleet = new Spaceship[6];

public void init() {
  for (int i=0; i<30; i++) { //initialize all elements
    streaks[i] = new Stars();
  }
  for (int q=0; q<15; q++) {
    if (q<13) {
      rocks.add(new Asteroid());
    } else {
      rocks.add(new Enemy());
    }
  }
  for (int i=0; i<complexity; i++) {
    systems[i]=new Celestial(i);
  }
  for (int i=0; i<6; i++) {
    Fleet[i]=new Spaceship((i%3)*100+250, ((i/3)+1)*100+50, true);
  }
  playing=true;
  myhealth=100;
  Jeremiah =new Spaceship(550, 40, false);
}

void setup() {
  size(1100, 700, P3D);
  init();
}

void draw() {
  if (playing==true) {
    if (millis()%1000<2) {
      System.out.println(rocks.size());
    }
    background(0, 0, 0);
    pushMatrix();
    translate(-4550, -2900, -5000); //move stars and background behind asteroid
    scale(9.3, 9.3);
    for (int i=0; i<30; i++) { //draw stars
      streaks[i].paint();
    }
    scale(7, 7);
    translate(-550, -350, 1);
    for (int i=0; i<complexity; i++) { //draw planets in background
      systems[i].gravity(i);
      systems[i].move();
      systems[i].show();
    }
    popMatrix();

    for (int q=0; q<rocks.size(); q++) {    
      if (rocks.get(q).getExstatus()>0) { //if hit, explode asteroids
        rocks.get(q).explode();
      }
      rocks.get(q).render(); //draw asteroids and enemy ships
      rocks.get(q).extrastuff(q); //steer enemy ship
      if (rocks.get(q).getExstatus()>400) {
        rocks.remove(q);
        q-=1;
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
      if (keyCode==DOWN) { //teleports ship to new location\
        Jeremiah.hyperspace();
        keyCode=0;
      }
      if (key==' ') { //fires lasers
        blasts.add(new Lasers());
        for (int i=0; i<6; i++) {
          if (Fleet[i].gethealth()>0) {
            blasts.add(new Lasers(Fleet[i]));
          }
        }
      }
      key='a';
    } else {
      Jeremiah.slow();
    }


    Jeremiah.show(); 
    Jeremiah.move();  
    Jeremiah.setX(constrain(Jeremiah.getX(), 50, 1050));
    Jeremiah.setY(constrain(Jeremiah.getY(), 50, 650));

    for (int i=0; i<6; i++) {
      Fleet[i].show();
      Fleet[i].follow(Jeremiah, (int)(((i+2)%2*100*((i+2)/2))-(50*((i+2)/2))), ((i/2)+1)*80);
      Fleet[i].move();
    }

    for (int z=0; z<blasts.size(); z++) { //draw lasers
      blasts.get(z).show();
      blasts.get(z).scan();
      float x=blasts.get(z).getX();
      float y=blasts.get(z).getY();

      if (x>1100 || y>700 ||x<0|| y<0) {
        blasts.remove(z);
        z-=1;
        System.out.println(blasts.size());
      }
    }
    strokeWeight(0);
    fill(300, 0, 0);
    rect(890, 30, (int)myhealth, 20);
    fill(300, 300, 300);  
    rect(890+myhealth, 30, 100-myhealth, 20);  
    textSize(30);
    text(myhealth, 1020, 35); //display health

    if (myhealth<5 || rocks.size()<2) {
      playing=false;
      timer=0;
    }
  } else {
    timer+=1;
    background(0, 0, 0);
    fill(255, 255, 255);
    textSize(80);
    text("Game Over: ",150,250);
    text("Your score is "+ myhealth, 150, 330);
    int tinty = abs(300-(millis()%600));
        int tinty2 = abs(900-(millis()%1800))/3;
        tinty=constrain(tinty, 10, 290);
        tinty2=constrain(tinty2, 10, 290);
        fill(tinty2, 300-tinty, tinty);
        textSize(50);
        text("Click Any Key to Play Again!", 100, 600);
    if(keyPressed==true && timer>100){
      init();
    }
  }
}

class BaseObj {
  protected float[] loc;
  protected float[] vel;
  protected float[] rot;
  protected float[] tor;

  void render() {
    pushMatrix();
    translate(loc[0], loc[1], loc[2]);
    rotateX(rot[0]);
    rotateY(rot[1]);
    rotateZ(rot[2]);
    for (int i=0; i<3; i++) {
      loc[i]+=vel[i]; 
      rot[i]+=tor[i];
    }
    show();
    popMatrix();
  }

  public void setrandomly() {
    float[] locset = {random(0, 1100), random(0, 700), random(-100, 100)}; 
    loc=locset;
    float[] velset = {random(-1, 1), random(-1, 1), random(0, 0)}; 
    vel=velset;
    float[] rotset = {random(-8, 8), random(-8, 8), random(-8, 8)}; 
    rot=rotset;
    float[] torset = {random(-.01, .01), random(-.01, .01), random(-.01, .01)}; 
    tor=torset;
  }

  void show() {
  }

  float[] getLoc() {
    return loc;
  }
  float[] getVel() {
    return vel;
  }
  float[] getRot() {
    return rot;
  }
  float[] getTor() {
    return tor;
  }
  void setLoc(float[] l) {
    loc=l;
  }
  void setVel(float[] v) {
    vel=v;
  }
  void setRot(float[] r) {
    rot=r;
  }
  void setTor(float[] t) {
    tor=t;
  }
  void setExstatus(int something) {
  }
  int getExstatus() {
    return 1;
  }

  void extrastuff(int value) {
  }
  void explode() {
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

    if (value<complexity-3) {
      float radius=random(100, 400);
      float theta=random(0, 7);
      x=(int)((cos(theta)*radius)+550);
      y=(int)((sin(theta)*radius)+350);
      theta+=3.14159/2;
      yvelocity=sin(theta)*(sqrt(speediness*4000/radius))*random(.8, 1.2);
      xvelocity=cos(theta)*(sqrt(speediness*4000/radius));
    } else if (value>complexity-2) {
      mass=4000;
      x=550; 
      y=350;
      s=25;
      tint=color(255, 150, 50);
      xvelocity=0;
      yvelocity=0;
    } else {
      x=(int)(random(100, 1000));
      y=(int)(random(100, 700));
      xvelocity=random(-3, 3);
      yvelocity=random(-3, 3);
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
    if (mass>200) {
      //PImage Sun = loadImage("Psun.png");
      fill(255, 255, 0, 100);
      ellipse(x, y, s+18, s+18);
      //fill(255, 100, 50,100);
      //ellipse(x,y,s+22,s+22);
      //image(Sun,x-20,y-20,40,40);

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

class Lasers extends Stars {
  private float velocity, theta;
  Lasers() { //constructor for good guy lasers
    velocity=Jeremiah.getV()+10;
    theta=Jeremiah.getTheta()*(float)Math.PI/180;
    x=Jeremiah.getX()+(cos(theta)*20);
    y=Jeremiah.getY()+(sin(theta)*20);
    mycolor=color(0, 0, 255);
    s=10;
  }
  Lasers(Spaceship take) { //constructor for backup fleet
    velocity=Jeremiah.getV()+10;
    theta=take.getTheta()*(float)Math.PI/180;
    x=take.getX()+(cos(theta)*20);
    y=take.getY()+(sin(theta)*20);
    mycolor=color(0, 0, 255);
    s=6;
  }
  Lasers(int sender, float angle) { //constructor for enemy lasers
    x=rocks.get(sender).loc[0];
    y=rocks.get(sender).loc[1];
    velocity=10;
    mycolor=color(200, 0, 0);
    theta=angle;
    s=10;
  }
  void show() { //display lasers
    fill(mycolor);
    ellipse(x, y, s, s);
    x+=cos(theta)*velocity;
    y+=sin(theta)*velocity;
  }

  float getX() {
    return x;
  }
  float getY() {
    return y;
  }

  void scan() {
    for (int i=0; i<rocks.size(); i++) { //check to see if laser hit asteroid, if so, tell asteroid to blow up
      int x1 = (int)rocks.get(i).getLoc()[0];
      int y1 = (int)rocks.get(i).getLoc()[1];
      if (dist(x, y, x1, y1)<50 &&rocks.get(i).getExstatus()==0 &&(i<13||mycolor!=color(200, 0, 0))) {
        rocks.get(i).setExstatus(1);
        x=1200;
        velocity=0;
      }
    }
    if (dist(x, y, Jeremiah.getX(), Jeremiah.getY())<20) { // if laser hits ship, lower health
      myhealth-=10;
      x=1200;
      Jeremiah.sethit(50);
      velocity=0;
    }
    for (int i=0; i<6; i++) {
      if (dist(x, y, Fleet[i].getX(), Fleet[i].getY())<20) { // if laser hits ship, lower health
        Fleet[i].sethealth(0);
        x=1200;
        Fleet[i].sethit(50);
        velocity=0;
      }
    }
  }
}
