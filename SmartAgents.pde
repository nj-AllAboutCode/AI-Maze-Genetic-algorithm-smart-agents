

int lifetime; 

Population population;  // Population

int lifecycle;          // Timer for cycle of generation
int recordtime;         // Fastest time to target

Obstacle target;        // Target position

//int diam = 24;          // Size of target

ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!

void setup() {
  size(900, 500);
  // The number of cycles we will allow a generation to live
  lifetime = width;

  // Initialize variables
  lifecycle = 0;
  recordtime = lifetime;

  target = new Obstacle(width-40, height/2-20, 40, 40);

  // Create a population with a mutation rate, and population max
  float mutationRate = 0.025;
  population = new Population(mutationRate, 1000);

  obstacles = new ArrayList<Obstacle>();

  obstacles.add(new Obstacle(200, 0, 15, height/2));
  obstacles.add(new Obstacle(300, 200, 15, 400));

  obstacles.add(new Obstacle(450, 0, 15, height/2));
  obstacles.add(new Obstacle(450, height-200, 15, 200));

  obstacles.add(new Obstacle(600, 0, 15, 350));

  obstacles.add(new Obstacle(760, height-350, 15, 350));
}

void draw() {
  background(51);

  target.display();


  if (lifecycle < lifetime) {
    population.live(obstacles);
    if ((population.targetReached()) && (lifecycle < recordtime)) {
      recordtime = lifecycle;
    }
    lifecycle++;
  } else {
    lifecycle = 0;
    population.fitness();
    population.selection();
    population.reproduction();
  }

  for (Obstacle obs : obstacles) {
    obs.display();
  }

  fill(255);
  createFont("consolas", 20);

  text("Generation: " + population.getGenerations(), width-200, 20);
}
