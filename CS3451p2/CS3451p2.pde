// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
int maxRegionCount = 64;
pts [] Region = new pts[maxRegionCount]; // array of region

pts cutPiece_P;
pts remain_P;
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points
int newPoly = 0; // number of new polygon cut out
pt A = P(100,100); pt B = P(300,300);
boolean locked = false;
boolean overBox = false;
float x = 0.0, y = 0.0; 
//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  size(800, 800);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
  P.loadPts("data/pts");  // loads points form file saved with this program
  for (int r=0; r<maxRegionCount; r++){
    Region[r] = new pts(); 
  }
  Region[0] = P;
} // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
    background(white); // clear screen and paints white background
    pen(black,3); fill(yellow); Region[0].drawCurve(); Region[0].IDs(); // shows polylon with vertex labels
    stroke(red); pt G=Region[0].Centroid(); show(G,10); // shows centroid
    
    boolean goodSplit = Region[0].splitBy(A,B);
    if (goodSplit == true) {
      //newPoly++;
      Region[0].performSplit(A,B);
      cutPolygons();
      //split_P.declare();
      for (int r=0; r<maxRegionCount; r++){
        if(Region[r] == null){
          
        }
      }
    }else{
      pen(red,7);
    }
    
    //arrow(A,B);
    

               // defines line style wiht (5) and color (green) and draws starting arrow from A to B


  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  
void cutPolygons() {
  cutPiece_P = new pts();
  remain_P = new pts();
}

  