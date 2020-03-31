import processing.sound.*;
import processing.serial.*;


SoundFile file;
SoundFile eat;


Serial p1,p2;
String gval;
int x_food, y_food;
int nop=0;
int state=0;
Boolean check1=true,check2=true;
Snake s2;
Snake s;
PImage img;
int starttime=0;
int tleft;
int sp1=20,sp2=20;
Boolean p1_c=false,p2_c=false;
int win_p=0;


void setup() {
  img=loadImage("snake.jpg");
  size(500, 500); // window size
  
  textSize(40);
 
  s2 = new Snake(int(random(255)),int(random(255)),int(random(255)));
  s=new Snake(int(random(255)),int(random(255)),int(random(255)));
  s2.update((int)random (0, 16), (int)random (0, 16));
  s.update((int)random (0, 16), (int)random (0, 16));
  generate_food();
  

 for(int i=0;i<4;i++)s2.grow();
 for(int i=0;i<4;i++)s.grow();
 file= new SoundFile(this,sketchPath("tetris.mp3"));
 eat= new SoundFile(this,sketchPath("eat.mp3"));
 file.loop();
 
}

void draw() {
  if(state==0){
    //print("on");
    screen();
  }
  else if(state==1){
  background(255); // white background
  if(!check1){
  if(s2.mx == x_food && s2.my == y_food) {
      eat.play();
      s2.grow();
      while(s2.food(x_food, y_food)) {
        generate_food();
      }
      
  }
  }
  
  if(!check2){
    if(s.mx == x_food && s.my == y_food) {
      eat.play();
      s.grow();
      while(s.food(x_food, y_food)) {
        generate_food();
      }
      
  }
  }
  
  fill(255, 0, 0);
  rect(x_food * 20, y_food * 20, 20, 20);
  if(!check1)s2.draw();
  if(!check2)s.draw();
  gmove(); 
  if(!check1)if(s2.time%sp1==0)s2.move(s2.last_move,1);
  if(!check2)if(s.time%sp2==0)s.move(s.last_move,1);
  fill(255, 0, 0);
  tleft=60-(millis()-starttime)/1000;
  text("time"+tleft,0, 40);
  if(!check1)s2.time+=1;
  if(!check2)s.time+=1;
  /*if(nop==2){
    if(s2.intersect()){state=2;win_p=1;}
    if(s.intersect()){state=2;win_p=2;}
  }
  if(nop==1){
    if(!check1){
      if(s2.intersect())state=2;
    }
    if(!check2){
      if(s.intersect())state=2;
    }
  }*/
  if(tleft==0){
    state=2;
    if(s2.score>s.score)win_p=1;
    if(s.score>s2.score)win_p=2;
    else win_p=0;
  }
  }
  if(state==2){
    end_screen(win_p);
  }
}

void keyPressed(){
  if(key==CODED){
    if(keyCode==UP)s2.move(4,0);
    if(keyCode==DOWN)s2.move(3,0);
    if(keyCode==RIGHT)s2.move(1,0);
    if(keyCode==LEFT)s2.move(2,0);
  }
  else{
    if(key=='w')s.move(4,0);
    if(key=='a')s.move(2,0);
    if(key=='s')s.move(3,0);
    if(key=='d')s.move(1,0);
    if(key=='k'){
      if(nop>0)state=1;
      starttime=millis();
    }
   // if(key=='t'){state=2;}
      
  }
}


void generate_food() {
      x_food = (int)random(0, 16);
      y_food = (int)random(0, 16);
}

void gmove(){
  if(!check1){gval=p1.readStringUntil('\n');
  if(gval!=null){
    gval=gval.trim();
    String[] lval=split(gval,',');
    if(lval.length==4){
      if(Integer.parseInt(lval[1])<-15)s2.move(4,0);
      if(Integer.parseInt(lval[1])>18)s2.move(3,0);
      if(Integer.parseInt(lval[2])<-15)s2.move(1,0);
      if(Integer.parseInt(lval[2])>15)s2.move(2,0);
      sp1=Integer.parseInt(lval[3]);
    }
  }
  }
  if(!check2){
  gval=p2.readStringUntil('\n');
  if(gval!=null){
    gval=gval.trim();
    String[] lval=split(gval,',');
    if(lval.length==4){
      if(Integer.parseInt(lval[1])<-25)s.move(4,0);
      if(Integer.parseInt(lval[1])>25)s.move(3,0);
      if(Integer.parseInt(lval[2])<-25)s.move(1,0);
      if(Integer.parseInt(lval[2])>25)s.move(2,0);
      sp2=Integer.parseInt(lval[3]);
    }
  }
  }
}
