// Import video and control libraries
   import processing.video.*;
   import processing.core.PImage;

   // Constants for setup
   int videoWidth = 1920;
   int videoHeight = 1080;
   int frameRate = 30;
   int totalFrames = 600; // For 20 seconds video (20s x 30 fps)

   // ArrayList to hold squares
   ArrayList<Square> squares;

   // Variables for color tone
   color peachFuzz;

   // MovieMaker object to create video
   MovieMaker video;

   // Image for the frame background
   PImage frameImage;

   void setup() {
     size(videoWidth, videoHeight);
     frameRate(frameRate);
     peachFuzz = color(255, 218, 185); // Approximate color for PANTONE 13-1023 Peach Fuzz

     // Load the frame image
     frameImage = loadImage("../Design sem nome.png");
     frameImage.resize(441, 484);

     squares = new ArrayList<Square>();

     // Create initial squares
     for (int i = 0; i < 5; i++) {
       squares.add(new Square(random(width), random(height), peachFuzz));
     }

     // Initialize video output
     video = new MovieMaker(this, videoWidth, videoHeight, "output/peach_fuzz_video.mp4", frameRate, MovieMaker.H264, MovieMaker.HIGH);
   }

   void draw() {
     background(0);

     // Draw the frame image in the center of the canvas
     image(frameImage, (width - frameImage.width) / 2, (height - frameImage.height) / 2);

     // Draw and update squares
     for (Square s : squares) {
       s.display();
       s.update();
     }

     // Add new squares at random intervals
     if (frameCount % 20 == 0) {
       squares.add(new Square(random(width), random(height), peachFuzz));
     }

     // Interact between squares
     for (int i = 0; i < squares.size(); i++) {
       for (int j = i + 1; j < squares.size(); j++) {
         if (squares.get(i).intersects(squares.get(j))) {
           squares.get(i).changeColor();
           squares.get(j).changeColor();
         }
       }
     }

     // Save frame to video
     video.addFrame();

     // Stop recording after totalFrames
     if (frameCount >= totalFrames) {
       video.finish();
       exit();
     }
   }

   class Square {
     float x, y;
     float size;
     color col;

     Square(float tempX, float tempY, color tempCol) {
       x = tempX;
       y = tempY;
       size = random(30, 70);
       col = tempCol;
     }

     void display() {
       fill(col);
       noStroke();
       rect(x, y, size, size);
     }

     void update() {
       // Movement logic for slight bouncing effect
       x += random(-2, 2);
       y += random(-2, 2);
     }

     void changeColor() {
       // Generate a slightly different shade of Peach Fuzz
       col = color(red(col) + random(-10, 10), green(col) + random(-10, 10), blue(col) + random(-10, 10));
     }

     boolean intersects(Square other) {
       return !(x + size < other.x || x > other.x + other.size || y + size < other.y || y > other.y + other.size);
     }
   }