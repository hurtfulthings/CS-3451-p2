// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
int maxRegionCount = 64;
pts [] Region = new pts[maxRegionCount]; // array of region

pts verticesToSave = new pts();
pts cutPiece_P = new pts();
pts remain_P = new pts();
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points
int next = 0; // next index of region array
int previous = 0; // previous region in the array
int current = 0; // current region in the array
int newVertices = 0; // index of vertices of the new polygon
int oldVertices = 0; // index of vertices of the old polygon
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
  cutPiece_P.declare(); // declares all points in the cut polygon. MUST BE DONE BEFORE ADDING POINTS
  remain_P.declare(); // declares all points in the remaining polygon. MUST BE DONE BEFORE ADDING POINTS
  verticesToSave.declare();
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
    pen(black,3); Region[Region.length-1].drawCurve();
    pen(black,3); fill(yellow); Region[0].drawCurve(); Region[0].IDs(); // shows polylon with vertex labels
    stroke(red); pt G=Region[0].Centroid(); show(G,10); // shows centroid
    
    boolean goodSplit = Region[0].splitBy(A,B);
    if (goodSplit == true) {
      verticesToSave = Region[0].performSplit(A,B); // cutPiece_P has vertices A_l & B_l of the cut-out piece
      pt firstInd_A = verticesToSave.getPt(0);
      pt lastInd_A = verticesToSave.getPt(2);
      pt firstInd_B = verticesToSave.getPt(3);
      pt lastInd_B = verticesToSave.getPt(5);
      cutPiece_P = createPuzzlePoly(Region, int s, int e, pt A, pt B, pts P);
    }else{
      pen(red,7);
    }
    
    arrow(A,B);
    

               // defines line style wiht (5) and color (green) and draws starting arrow from A to B


  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  
//*****************************************************************************
//************************************************************************
//**** HELPER POLYGON METHODS
//************************************************************************
  
//void cutPolygons() {
//  cutPiece_P = new pts();
//  remain_P = new pts();
//}
  pts createRemainPoly(pts[] R, int s, int e, pt A, pt B, pts P){  // inserts new polygon region in front of the original
    P.insertPt(A);
    for (int v = s+1; v < e; v++){
      P.insertPt(R[2].getPt(v));
    }
    P.insertPt(B);
  return P;
  }
  
  pts createPuzzlePoly(pts[] R, int s, int e, pt A, pt B, pts P){
    P.insertPt(A);
    while(R[2].getPt(R[2].p(s))!= R[2].getPt(e)){
      s = R[2].p(s);
    }
    P.insertPt(B);
  return P;
  }
  