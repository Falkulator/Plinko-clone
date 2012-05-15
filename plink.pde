


Bin bin;

float gravity = 0.04, 
			damping = 0.8,
			amountpegs = 10.0,
			maxspeed = 3.0;

ArrayList pegs, balls; 


void setup() {
	size(350, 800);
	background(100);
	stroke(255);
	balls = new ArrayList;
  ball = new Ball(46, 5, 5);
	balls.add(ball);
	createpegs();
	bin = new Bin(50, 750, 50, 50); 
}

void draw() {
  noStroke();

  fill(0, 50);

  rect(0, 0, width, height);

	stroke(200);

	for (int i=0; i<pegs.size(); i++) {
		ellipse(pegs.get(i).x, pegs.get(i).y, pegs.get(i).r*2, pegs.get(i).r*2);
	}

	bin.draw();

	for (int i=0; i<balls.size(); i++) {

		ball = balls.get(i);

		ball.x += ball.vx;
		ball.vy += gravity;
		ball.y += ball.vy;
		ball.maxv();

		noStroke();
		fill(ball.rgb1, ball.rgb2, ball.rgb3);
		ellipse(ball.x, ball.y, ball.r*2, ball.r*2);

  // collision detection
    checkPegCollision(ball);
  	checkWallCollision(ball);
		checkBinCollision(ball);

		if (ball.y > height) {
			removeOldBalls(ball);
		}

	}



}

void checkWallCollision(Ball ball){

  if (ball.x > width-ball.r){

    ball.x = width-ball.r;

    ball.vx *= -1;

    ball.vx *= damping;

  } 

  else if (ball.x < ball.r){

    ball.x = ball.r;

    ball.vx *= -1;

    ball.vx *= damping;

  }

}





void checkPegCollision(Ball ball) {
	
	for (int i=0; i<pegs.size(); i++) {
		float dx, dy;
		if ((ball.y + ball.r) >= (pegs.get(i).y - pegs.get(i).r) &&
				(ball.y - ball.r) <= (pegs.get(i).y + pegs.get(i).r) &&
				(ball.x + ball.r) >= (pegs.get(i).x - pegs.get(i).r) &&
				(ball.x - ball.r) <= (pegs.get(i).x + pegs.get(i).r)) {
					
					// collision logic
					dx = ball.x - pegs.get(i).x;
					dy = ball.y - pegs.get(i).y;
					if (dx == 0) {
						dx = random(-0.01, 0.01);
					}
					ball.vx += (dx * 0.2);
					ball.vy += (dy * 0.2);

					ball.rgb1 = random(250);
					ball.rgb2 = random(250);
					ball.rgb3 = random(250);
		}
	}
}

void checkBinCollision(Ball ball) {

	if ((bin.x - bin.width/2) < (ball.x - ball.r) &&
			(bin.x + bin.width/2) > (ball.x + ball.r) &&
			(bin.y < (ball.y + ball.r)) &&
			(ball.y < bin.y)) {
		
		//collision logic for bottom of the bin
		ball.vy = -0.1 + -(abs(ball.vy) * damping);

	}


		//inside the bin
	if ((ball.x + ball.r) > (bin.x - bin.width/2) &&
			(ball.x - ball.r) < (bin.x - bin.width/2) &&
			(ball.y - ball.r) < bin.y &&
			(ball.y ) > (bin.y - bin.height)) {
		
		//collision logic for left of the bin	inside	
		ball.vx = 1;

	}

	if ((ball.x + ball.r) > (bin.x + bin.width/2) &&
			(ball.x - ball.r) < (bin.x + bin.width/2) &&
			(ball.y ) < bin.y &&
			(ball.y ) > (bin.y - bin.height)) {
		
		//collision logic for right of the bin inside
		ball.vx = -1;

	}
	
		//outside the bin
	if ((ball.x + ball.r) > (bin.x - bin.width/2) &&
			(ball.x - ball.r) < (bin.x - bin.width/2) &&
			(ball.x < (bin.x - bin.width/2)) &&
			(ball.y - ball.r) < bin.y &&
			(ball.y ) > (bin.y - bin.height)) {
		
		//collision logic for left of the bin	outside	
		ball.vx = -(abs(ball.vx) * damping);

	}
	
	if ((ball.x + ball.r) > (bin.x - bin.width/2) &&
			(ball.x - ball.r) < (bin.x - bin.width/2) &&
			(ball.x > (bin.x + bin.width/2)) &&
			(ball.y - ball.r) < bin.y &&
			(ball.y ) > (bin.y - bin.height)) {
		
		//collision logic for right of the bin	outside	
		ball.vx = (abs(ball.vx) * damping);

	}
}

void removeOldBalls(Ball ball) {
	int i = balls.indexOf(ball);
	balls.remove(i);
}

void mouseReleased() {
	if (mouseY < 250)	{
		ball = new Ball(mouseX, mouseY, 5);
		balls.add(ball);
	}

}

void createpegs() {

	float x = 30, y= 250, xi = 45;
	pegs = new ArrayList();

	for (int i=0; i<amountpegs; i++) {


		for (int j=0; j<amountpegs; j++) {
			if (j % 2 == 0) {
				(float) xs = x + (i*30);
			} else if (j % 2 == 1) {
				(float) xs = xi + (i*30);
			}
			(float) ys = y + (j*35);
			peg = new Peg( xs, ys, 3.0);
			pegs.add(peg);
		}

	}
}

class Ball{

  float x, y, r, vx, vy;


  // default constructor

  Ball() {

  }

	void maxv() {
		if (this.vx > maxspeed) {
			this.vx = maxspeed;
		}
		if (this.vx < -maxspeed) {
			this.vx = -maxspeed;
		}
		if (this.vy > maxspeed) {
			this.vy = maxspeed;
		}
		if (this.vy < -maxspeed) {
			this.vy = -maxspeed;
		}
	}
  Ball(float x, float y, float r) {

    this.x = x;

    this.y = y;

    this.r = r;

		this.vx = 0;

		this.vy = 0;

		this.rgb1 = 250;

		this.rgb2 = 250;

		this.rgb3 = 250;
  }

}

class Peg{

  float x, y, r;



  // default constructor

  Peg() {

  }



  Peg(float x, float y, float r) {

    this.x = x;

    this.y = y;

    this.r = r;

  }


}

class Bin{

	Bin() {

	}

	void draw() {
		
		stroke(200);
		line(this.x - this.width/2, this.y, this.x - this.width/2, this.y - this.height);
		line(this.x - this.width/2, this.y, this.x + this.width/2, this.y);
		line(this.x + this.width/2, this.y, this.x + this.width/2, this.y - this.height);

		//bin oscillation
		if (this.x > 279) {
			this.dx = -0.8;
		}
		if (this.x < 50) {
			this.dx = 0.8;
		}

		this.x += this.dx;
	}

	Bin(float x, float y, float width, float height) {

		this.width = width;
		this.height = height;
		this.x = x;
		this.y = y;
		this.dx = 0.8;

	}
}


class Vect2D{

  float vx, vy;



  // default constructor

  Vect2D() {

  }



  Vect2D(float vx, float vy) {

    this.vx = vx;

    this.vy = vy;

  }

}
