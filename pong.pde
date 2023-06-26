import processing.serial.*;
Serial myPort;
String dataSerial;

float radius = 15;
float x = 500;
float y = 250;
float y_react = 250;

//velocidade x e y
float xSpeed = 4;
int ySpeed = 4;

int score1 = 0;
int score2 = 0;
//posição, tempo, dificuldade
float conv;
int racket_skill = 4;
float position = 500;
int time;
//raquetes
PVector racketA;
PVector racketB;

void setup(){
  size(1000,500);
  frameRate(60);
  smooth(2);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.bufferUntil(10);
  
  noCursor();
}

//Coleta de dados do potenciometro
void serialEvent(Serial p){
  dataSerial = p.readString();
  float pInt = Float.valueOf(dataSerial);
  println(dataSerial);
  conv = map(pInt, 0, 1023, 50, 450);
  dataSerial = null;
}

void f_Difficulty(){
  float dif = score1 - score2;
  if(dif>=5 && score1 <10){
    position = 100;
    racket_skill = 10;
  }
  else if(dif >=5 && score1 >10){
    position = 100;
    racket_skill = 10;
  }
  xSpeed *= 1.001;
  x += xSpeed;
  y += ySpeed;
}

void f_collisionR(){
  racketA = new PVector(20-x, 0);
  racketB = new PVector(980-x, 0);
  
  float l_vector = racketA.mag();
  float r_vector = racketB.mag();
  
  if(l_vector < 25){
    boolean l_field = y < (conv + 50) && y > (conv - 50);
    if(l_field){
      xSpeed *= -1;
    }
    else if(!l_field){
      score2 += 1;
      xSpeed = 4;
      x = 500;
      y = 250;
      float randomica = random(1,3);
      if(randomica >= 2){
        xSpeed *= -1;
      }
    }
  }
  if(r_vector < 25){
    boolean r_field = y < (y_react+50) && y > (y_react - 50);
    if(r_field){
      xSpeed *= -1;
    }else if (!r_field){
      score1 += 1;
      xSpeed = 4;
      x = 500;
      y = 250;
      float randomica = random(1,3);
      if(randomica >= 2){
        xSpeed *= -1;
      }
    }
  }
}

void f_CollisionW(){
  if(y>500 || y < 0){
    ySpeed *= -1;
  }
}

void draw(){
  background(20);
  noStroke();
  
  f_collisionR();
  f_CollisionW();
  f_Difficulty();
  
  fill(255);
  ellipse(x,y,radius *2,radius *2);
  
  
  rectMode(CENTER);
  rect(500,250,3,500);
  rect(20,conv,15,100,10);
  
  if(x > position){
    if(y > y_react && y_react > 450){
      y_react += racket_skill;
    }else if(y < y_react && y_react > 50){
      y_react -= racket_skill;
    }
  }
  
}
