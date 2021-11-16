class Stars //note that this class does NOT extend Floater
{
class Stars {
  protected float x, y; //self explantory local viarables
  protected int mycolor, twinkle;
  protected float s = (int)random(0, 3);
  Stars() {
    x=(int)random(0, 1100); //place randomly on screen
    y=(int)(random(0, 700)); 
    mycolor=color(255, 255, 255);
    twinkle=1;
  }
  void paint() {
    if(twinkle==1){
      s+=.05; //make stars twinkle
    }else if(twinkle==-1){
      s-=.02;
    }
    if(s>4){twinkle=-1;}
    if(s<.5){twinkle=1;}
    fill(mycolor);
    noStroke();
    ellipse(x, y, s, s); //draw star
  }
}
}
