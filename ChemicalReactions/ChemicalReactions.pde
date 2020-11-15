// This is a simulation of Grey-Scott reactions 
// A very good explaination is detailed at: https://mrob.com/pub/comp/xmorphia/
// This code is the modified version of my own code (which worked slower) following The Coding Train video : https://www.youtube.com/watch?v=BV9ny785UNc&t=369s

// Screen and grid parameters
int screenWidth = 300;
int gridWidth = 300;
int cellWidth;

// Map of A and B
Cell[][] actual;
Cell[][] prev;

// Equation parameters
float initialA = 1;
float setBValue = 1;
float k = 0.062;
float Da = 1;
float Db = 0.5;
float f = 0.055;
float deltaTime = 1;
float d = 1;
float maxB = 1;

// Size of a drop when the user clicks
int sizeDrop = 10;

// To know the concentration of A and B at each location
class Cell {
  float a;
  float b;
  
  Cell(float a_ , float b_) {
    a = a_;
    b = b_;
  }
}


void setup(){
  size(300,300);
  
  cellWidth = screenWidth/gridWidth;
  
  Initialize();
  
  DrawReaction();
}

void draw(){
  println(frameRate);
  Reaction();
  DrawReaction();
  
  // We actualize the concentration after computing them
  Cell[][] temp = actual;
  prev = temp;

}



void mouseClicked(){
  // On click, put a drop of B in the reaction
  for (int i = -sizeDrop ; i<sizeDrop ; i++){
    for (int j = -sizeDrop ; j<sizeDrop ; j++){
      prev[mouseY / cellWidth + i][mouseX / cellWidth + j].b = setBValue;
    }
  }
}


void Initialize(){
  // We fill the concentration of each cell in the grid
  actual = new Cell[gridWidth][gridWidth];

  prev = new Cell[gridWidth][gridWidth];
  
  for (int i = 0 ; i<gridWidth; i++){
    for (int j = 0 ; j<gridWidth ; j++){
      actual[i][j] = new Cell ( initialA , 0 ) ; 
      prev[i][j] = new Cell ( initialA , 0 ) ; 
    }
  }
}


void Reaction(){
  for (int i = 1 ; i<gridWidth-1; i++){
    for (int j = 1 ; j<gridWidth-1 ; j++){
      
      // Equations of propagation and reaction
      
      float a = prev[i][j].a;
      float b = prev[i][j].b;
      
      float laplacienA = (0.2*prev[i][j-1].a + 0.2*prev[i-1][j].a + 0.2*prev[i+1][j].a + 0.2*prev[i][j+1].a
                          + 0.05*prev[i-1][j-1].a + 0.05*prev[i-1][j+1].a + 0.05*prev[i+1][j-1].a + 0.05*prev[i+1][j+1].a
                          -  prev[i][j].a )/d/d;
      
      float laplacienB = (0.2*prev[i][j-1].b + 0.2*prev[i-1][j].b + 0.2*prev[i+1][j].b + 0.2*prev[i][j+1].b
                          + 0.05*prev[i-1][j-1].b + 0.05*prev[i-1][j+1].b + 0.05*prev[i+1][j-1].b + 0.05*prev[i+1][j+1].b
                          -  prev[i][j].b )/d/d;    
      
      // The first term is for propagation
      // The second term is for the reaction
      // The third term is the impact of a continuous encrease of A 
      actual[i][j].a = a + deltaTime* (Da*     laplacienA    - a  * b* b + f*(1-a ) );
      actual[i][j].b = b + deltaTime* (Db*     laplacienB      + a * b* b - (f + k)*b);

      // The values can't be higher than 1 or lower than 0 (as they are proportions)
      actual[i][j].a = max(0 , min(1, actual[i][j].a));
      actual[i][j].b = max(0 , min(1, actual[i][j].b));
    }
  }

}


void DrawReaction(){
  
  // We should have to modify this section in order to make the program correct when gridWidth != screenWidth 
  // It can be done by drawing a square of size screenWidth/gridWidth on each cell (each i,j value in [0 , gridWidth])
  loadPixels();
  for (int i = 1; i < screenWidth-1; i++) {
    for (int j = 1; j < screenWidth-1; j ++) {
      Cell spot = actual[i][j];
      float a = spot.a;
      float b = spot.b;
      int pos = j + i * screenWidth;
      pixels[pos] = color((a-b)*255);
    }
  }
  updatePixels();
  
}
