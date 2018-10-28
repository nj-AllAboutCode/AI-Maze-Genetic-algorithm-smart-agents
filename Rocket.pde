class Rocket {

  PVector position;
  PVector velocity;
  PVector acceleration;

  // Size
  float r;

  float recordDist;

  // Fitness and DNA
  float fitness;
  DNA dna;
  int geneCounter = 0;

  boolean hitObstacle = false;    
  boolean hitTarget = false;   
  int finishTime;             

  //constructor
  Rocket(PVector l, DNA dna_, int totalRockets) {
    acceleration = new PVector();
    velocity = new PVector();
    position = l.get();
    r = 5;
    dna = dna_;
    finishTime = 0;          // We're going to count how long it takes to reach target
    recordDist = 10000;      // Some high number that will be beat instantly
  }

  // FITNESS FUNCTION 
  // distance = distance from target
  // finish = what order did i finish (first, second, etc. . .)
  // f(distance,finish) =   (1.0f / finish^1.5) * (1.0f / distance^6);
  // a lower finish is rewarded (exponentially) and/or shorter distance to target (exponetially)
  void fitness() {
    if (recordDist < 1) recordDist = 1;

    // Reward finishing faster and getting close
    fitness = (1/(finishTime*recordDist*recordDist));

    // Make the function exponential
    fitness = pow(fitness, 4);

    if (hitObstacle) fitness *= 0.4; // lose 90% of fitness hitting an obstacle
    if (hitTarget) fitness *= 3; // twice the fitness for finishing!
  }

  // Run in relation to all the obstacles
  // If I'm stuck, don't bother updating or checking for intersection
  void run(ArrayList<Obstacle> os) {
    if (!hitObstacle && !hitTarget) {
      applyForce(dna.genes[geneCounter]);
      geneCounter = (geneCounter + 1) % dna.genes.length;
      update();
      // If I hit an edge or an obstacle
      obstacles(os);
    }
    // Draw me!
    if (!hitObstacle) {
      display();
    }
  }

  // Did I make it to the target?
  void checkTarget() {
    float d = dist(position.x, position.y, target.position.x, target.position.y);
    if (d < recordDist) recordDist = d;

    if (target.contains(position) && !hitTarget) {
      hitTarget = true;
    } else if (!hitTarget) {
      finishTime++;
    }
  }

  // Did I hit an obstacle?
  void obstacles(ArrayList<Obstacle> os) {
    for (Obstacle obs : os) {
      if (obs.contains(position)) {
        hitObstacle = true;
      }
    }
    if (position.x < 0 || position.y < 0 || position.y > height) {
      hitObstacle = true;
    }
  }

  void applyForce(PVector f) {
    acceleration.add(f);
  }


  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    //background(255,0,0);
    float theta = velocity.heading2D() + PI/2;
    fill(200, 100);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);

    // Rocket body
    noFill();
    stroke(10,255,100);
    strokeWeight(4);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();

    popMatrix();
  }

  float getFitness() {
    return fitness;
  }

  DNA getDNA() {
    return dna;
  }

  boolean stopped() {
    return hitObstacle;
  }
}
