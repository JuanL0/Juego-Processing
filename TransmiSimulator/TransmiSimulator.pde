int resX = 600;
int resY = 600;
//int rot = 0;

int pantalla = 0; // 0: Peñalosa 1: Juego
int nivel = 1; // 1, 2, 3 - velocidad enemigos
int aviso = 0; // 0: Instrucciones 1: Juego 2: Gameover 3: Segundo nivel 4: Tercer nivel 5: Fin del juego 

int vida[] = new int [15];
int clase[] = new int [15];
float posX[] = new float [15];
float posY[] = new float [15];
float velX[] = new float [15];
float velY[] = new float [15];
float vel = 0;
int elliRad = 40; // Radio elipse 

float distan = 0;
float mX = resX/2; // Ultima posicion del mouse en X
float mY = resY/2; // Ultima posicion del mouse en y
int ultGol = -1; // Id del ultimo enemigo que me golpeo
int ultGolT = -1; // Tiempo de invulnerabilidad

int tiempo = 1;
int frames = 0;
int puntos = 13500;

PImage pan_0;
PImage pan_1;
PImage pan_2;
PImage pan_3;
PImage pan_4;
PImage pan_5;

PImage transmi;
PImage fondo;
PImage pen;
PImage est;
PImage pre;
PImage rap;
PImage ven;
PImage cho;

int almuX = 272;
int almuY = 310;

void setup(){
  size(600,600);
  frameRate(60);
  
  //Pantallas
  pan_0 = loadImage("Pantalla-0.png");
  pan_1 = loadImage("Pantalla-1.png");
  pan_2 = loadImage("Pantalla-2.png");
  pan_3 = loadImage("Pantalla-3.png");
  pan_4 = loadImage("Pantalla-4.png");
  pan_5 = loadImage("Pantalla-5.png");
  
  //Assets del juego
  transmi = loadImage("Transmi.png");
  fondo = loadImage("Carretera.png");
  pen = loadImage("TuPeñis.png");
  est = loadImage("Est.png");
  pre = loadImage("Pre.png");
  rap = loadImage("Rap.png");
  ven = loadImage("Ven.png");
  cho = loadImage("Cho.png");
  
  crearEnemigos();
}

void draw(){
  background(150);
  
  switch(pantalla){ // Pantallas
    case 0:
      inicio();
      break;
    case 1:
      niveles();
      break;
  }
}

void crearEnemigos(){
  
  //Creador de enemigos
  for(int i = 0; i < 15; i++){
    vida[i] = 1;
    clase[i] = int(random(0,4));
    posX[i] = random(-200,-195);
    posY[i] = random(-60,60);
    
    // Asigna diferentes velocidades segun el tipo de enemigo
    switch(clase[i]){ 
      case 0: // Predicador
        vel = random(0.5,1.5);
        break;
      case 1: // Rapero
        vel = random(1,2);
        break;
      case 2: // Veneco
        vel = random(1.5,3);
        break;
      case 3: // Choro 
        vel = random(3,4);
        break;
    }
    
    velX[i] = vel;
    if(int(random(0,2)) == 1){
      velY[i] = vel;
    } else {
      velY[i] = random(vel) * -1;
    }
    
    println("Clase " + clase[i] + ": " + vel);
  }
}

void inicio(){
  imageMode(CORNER);
  image(pan_0,0,0,600,600);
  if(mouseX >= 0 && mouseX <= 600 && mouseY >= 520 && mouseY <= 520 + 50 && mousePressed){
    pantalla = 1;
  }
}

void niveles(){
  
  //Creacion del fondo y los enemigos
  pushMatrix(); 
  translate(resX/2,resY/2);
  /*rotate(radians(rot)); Se suponia que esto debia rotar pero al hacerlo mandaba al carajo las colisiones*/
  imageMode(CORNER);
  image(fondo,-400,-390,800,800);
  image(transmi,-255,-278,511,566);
  for(int i = 0; i < 15; i++){
    imageMode(CENTER);
    switch(clase[i]){
      case 0: //Predicador
        image(pre,posX[i],posY[i],elliRad,elliRad);
        break;
      case 1: //Rapero
        image(rap,posX[i],posY[i],elliRad,elliRad);
        break;
      case 2: //Veneco
        image(ven,posX[i],posY[i],elliRad,elliRad);
        break;
      case 3: //Choro 
        image(cho,posX[i],posY[i],elliRad,elliRad);
        break;
    }
  }
  imageMode(CORNER);
  image(pen,-300,-290,157,89);
  popMatrix();
  
  if(aviso == 0){
    if(avisos(1,300,500,179,491,165,40)){
      aviso += 1;
    }
  } else if(aviso == 1){
    if(tiempo <= 0 && nivel == 1){
      aviso = 3;
    } else if(tiempo <= 0 && nivel == 2){
      aviso = 4;
    } else if(tiempo <= 0 && nivel == 3){
      aviso = 5;
    } else if(puntos > 0){
      juego();
    }else{
      aviso = 2;
    }
  } else if(aviso == 2){
    if(avisos(2,300,160,188,327,221,40)){
      pantalla = 0;
      aviso = 0;
      nivel = 1;
      puntos = 13500;
      frames = 0;
      tiempo = 1;
      crearEnemigos();
    }
  } else if(aviso == 3){
    if(avisos(3,300,160,216,324,165,40)){
      aviso = 1;
      nivel = 2;
      frames = 0;
      tiempo = 1;
      crearEnemigos();
    }
  } else if(aviso == 4){
    if(avisos(4,300,160,216,324,165,40)){
      aviso = 1;
      nivel = 3;
      frames = 0;
      tiempo = 1;
      crearEnemigos();
    }
  } else if(aviso == 5){
    if(avisos(5,300,190,188,339,220,40)){
      pantalla = 0;
      aviso = 0;
      nivel = 1;
      puntos = 13500;
      frames = 0;
      tiempo = 1;
      crearEnemigos();
    }
  }
}

boolean avisos(int img, int anc, int alt, int botX, int botY, int botAnc, int botAlt){
  
  //Gris
  rectMode(CORNER);
  noStroke();
  fill(100,100,100,150);
  rect(0,0,600,600);
  
  //Aviso
  imageMode(CENTER);
  switch(img){
    case 1:
      image(pan_1,300,300,anc,alt);
      break;
    case 2:
      image(pan_2,300,300,anc,alt);
      break;
    case 3:
      image(pan_3,300,300,anc,alt);
      break;
    case 4:
      image(pan_4,300,300,anc,alt);
      break;
    case 5:
      image(pan_5,300,300,anc,alt);
      almuerzo();
      break;
  }
  if(mouseX >= botX && mouseX <= botX + botAnc && mouseY >= botY && mouseY <= botY + botAlt && mousePressed){
    return true;
  } else{
    return false; 
  }
}

void juego(){
  
 //Tiempo segun nivel
  tiempo = (40/nivel)+((frames/60)*-1);
  frames +=1;
  
  //HUD
  textSize(15);
  fill(230);
  text("Luquillas: " + puntos, 20, 65);
  text("Tiempo: " + tiempo, 20, 85);
  
  //Movimiento raton
  if(mouseX <= resX*0.875-elliRad/2 && mouseX >= resX*0.125+elliRad/2 && mouseY <= resX*0.875-elliRad/2 && mouseY >= resX*0.125+elliRad/2){
    fill(255,0,0);
    imageMode(CENTER);
    image(est,mouseX,mouseY,elliRad,elliRad);
    mX = mouseX;
    mY = mouseY;
  } else {
    fill(255,0,0);
    image(est,mX,mY,elliRad,elliRad);
  }
  
  //Movimiento enemigo
  for(int i = 0; i < 15; i++){
    if(posX[i] + elliRad/2 >= resX*0.75/2 || posX[i] - elliRad/2 <= resX*0.75/2 * -1){
      velX[i] *= -1; 
    }
    posX[i] += velX[i]*nivel;
    
    if(posY[i] + elliRad/2 >= resY*0.75/2 || posY[i] - elliRad/2 <= resY*0.75/2 * -1){
      velY[i] *= -1; 
    }
    posY[i] += velY[i]*nivel;
  }
  
  //Collider
  for(int i = 0; i < 15; i++){
    distan = dist(mX, mY, posX[i]+resX/2, posY[i]+resY/2);
    if(distan <= 30 && i != ultGol){
      ultGol = i;
      switch(clase[i]){ //Dinero perdido por golpe
        case 0: //Predicador
        puntos -= 2000;
        break;
      case 1: //Rapero
        puntos -= 1000;
        break;
      case 2: //Veneco
        puntos -= 700;
        break;
      case 3: //Choro 
        puntos -= 500;
        break;
      }
    }
  } 
}

void almuerzo(){
  textSize(14);
  fill(160,20,20,200);
  if(puntos > 12000){
    text("Subway", almuX, almuY);
  } else if(puntos > 1000){
    text("Pollito del Ara", almuX, almuY);
  } else if(puntos > 8500){
    text("Upa Gulupa", almuX, almuY); 
  } else if (puntos > 7000){
    text("Corrientazo en Isabellas", almuX, almuY);
  } else if (puntos > 6000){
    text("Tadeo Pizza", almuX, almuY);
  } else if (puntos > 5000){
    text("Combo 2 en Tipicas", almuX, almuY);
  } else if (puntos > 3000){
    text("Buñuelo + Gaseosa", almuX, almuY);
  } else if (puntos > 2000){
    text("Pola con cigarrillo", almuX, almuY);
  } else if (puntos > 1000){
    text("Barra de chocoramo", almuX, almuY);
  } else {
    text("Una menta", almuX, almuY); 
  }
}
