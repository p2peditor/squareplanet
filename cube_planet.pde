// https://www.reddit.com/r/theydidthemath/comments/4w3wbt/request_what_would_orbit_of_cube_shaped_planet/

PointMass Earth, Moon;
PointMass[] attractors;
int gridSize = 5;       // number of divisions horizontally and vertically
float gridWidth = 7E+6; // width of each side of the square of attractors
int numAttractors = gridSize * gridSize;

float realEarthMass    = 5.972E+24, // kg
      realEarthRadius  = 6.367E+6,  // m
      realMoonDistance = 3.85E+8,   // m
      realMoonMass     = 7.346E+22; // kg
      
// try realMoonDistance, 1E7, 9.5E6, 9E6
float orbitalRadius = 9.0E+6;
float period = 5.0; // seconds

float drawScale;

void setup() {
  Earth = new PointMass(0.0, 0.0, realEarthMass);
  Moon  = new PointMass(realMoonDistance, 0.0, realMoonMass);
  Moon.velocity = new Vec2(0.0, 1024.76852);
  
  // generate the attractors
  attractors = new PointMass[numAttractors];
  for(int h = 0; h < gridSize; h++)
  for(int v = 0; v < gridSize; v++) {
    float hPos = -gridWidth/2 + h*(gridWidth/(gridSize-1)),
          vPos = -gridWidth/2 + v*(gridWidth/(gridSize-1));
   PointMass p = new PointMass();
   p.position.x = hPos;
   p.position.y = vPos;
   p.mass = realEarthMass / numAttractors;
   attractors[h*gridSize + v] = p;
  }

  Moon = new PointMass(orbitalRadius, 0.0, 1.0);
  float speed = sqrt(CONSTS.G*realEarthMass / orbitalRadius); // v = sqrt(GM/r)
  Moon.velocity = new Vec2(0.0, speed);

  size(800,800);
  drawScale = (800/2 - 25)/orbitalRadius;

  smooth(2);
  background(0);
  stroke(255,255,255);
  fill(255,255,255);
  ellipseMode(RADIUS);

  // draw the earth;
  //float r = realEarthRadius * drawScale;
  //ellipse(400,400,r, r);
  
  // draw the attractors
  float r = realEarthRadius/2 * pow(1.0/numAttractors, 0.333) * drawScale;
  for(int i = 0; i < numAttractors; i++) {
   ellipse(400 + (attractors[i].position.x * drawScale),
           400 + (attractors[i].position.y * drawScale),
           r, r);
  }

}

void draw() {
  stroke(255,255,255);
  fill(255,255,255);
  
  // draw the moon
  set((int)(400 + Moon.position.x * drawScale),
      (int)(400 + Moon.position.y * drawScale),
      color(255));
  
  updateMoon(period);
}

// Move the moon through some number of seconds, then update its velocity vector
void updateMoon(float period) {

  // Move the moon by its current velocity
  Moon.position.x += (period * Moon.velocity.x);
  Moon.position.y += (period * Moon.velocity.y);
  
  // Update the velocity
  //Vec2 f = Moon.getForceVector(Earth); // Get the force between the two bodies
  //Vec2 a = new Vec2(f.x/Moon.mass, f.y/Moon.mass); // Convert it to an acceleration via F = ma; a = F/m
  //Moon.velocity.x += a.x * period; // dV = a*dt (delta-v = acceleration * delta-t)
  //Moon.velocity.y += a.y * period;

  for(int i = 0; i < numAttractors; i++) {
   Vec2 f = Moon.getForceVector(attractors[i]); // Get the force between the two bodies
   Vec2 a = new Vec2(f.x/Moon.mass, f.y/Moon.mass); // Convert it to an acceleration via F = ma; a = F/m
   Moon.velocity.x += a.x * period; // dV = a*dt (delta-v = acceleration * delta-t)
   Moon.velocity.y += a.y * period;
  }
// println("Moon at (" + Moon.position.x + ", " + Moon.position.y + ") going (" + Moon.velocity.x + ", " + Moon.velocity.y + ")");
}

void keyReleased() {
  save("orbit" + orbitalRadius + ".png");
}