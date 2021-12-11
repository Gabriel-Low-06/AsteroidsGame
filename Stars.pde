class Stars //note that this class does NOT extend Floater
{

  protected float x, y; //self explantory local viarables
  protected int mycolor, twinkle;
  protected float s = (int)random(0, 3);
  protected float velocity, theta;

  Stars() {
    x=(int)random(0, 1100); //place randomly on screen
    y=(int)(random(0, 700)); 
    mycolor=color(255, 255, 255);
    twinkle=1;
    theta=atan((y-350)/(x-550)); //point star to move away from center of screen
    if (x<550) {
      theta+=3.141592;
    }
    velocity=globalspeed/13;
    mycolor=color(255, 255, 255);
  }
  void paint() {
    if (twinkle==1) {
      s+=.03; //make stars twinkle
    } else if (twinkle==-1) {
      s-=.01;
    }
    if (s>2) {
      twinkle=-1;
    }
    if (s<.5) {
      twinkle=1;
    }
      velocity=globalspeed/13; //update velocity based on globalspeed
   // fill(mycolor);
   // noStroke();
    if (globalspeed<50) {
       pushMatrix();
       fill(mycolor);
       translate(x,y);
      sphere(s);
      popMatrix();
      
      //draw star
    } else {
      strokeWeight(s/25+1); //if moving fast, draw it as line
      if (globalspeed>300 && s<10) { //if in 'hyperspace' give blue tint
        mycolor=color(150, 200, 300);
      }
      stroke(mycolor);
      line(x, y, x-(velocity*cos(theta)), y-velocity*sin(theta));
    }
    x+=velocity*cos(theta);
    y+=velocity*sin(theta); //update position from velocity and rotation
  }
}
