public class Monitor {
	
	PFont myFont;
	PVector monitorPos;
	String statusText;
	int vibValue = 0;
	String modeText;
	
	Monitor() {
		
		myFont = createFont("Monaco", 10);
		textFont(myFont);
		
		monitorPos = new PVector(10, 20);
		
	}
	
	void display() {
		
		switch (status) {
			
			case 0:
			statusText = "SLEEP";
			break;
			
			case 1:
			statusText = "INIT";
			break;
			
			case 2:
			statusText = "READY";
			break;
			
			case 3:
			statusText = "GAME";
			break;
			
		}
		
		switch (mode) {
			
			case 0:
			modeText = "Normal";
			break;
			
			case 1:
			modeText = "Amateur 1";
			break;
			
			case 2:
			modeText = "Amateur 2";
			break;
			
		}
		
		pushMatrix();
		translate(monitorPos.x, monitorPos.y);
		fill(35, 35, 35);
		text("Mode: " + modeText, 0, 0);
		
		if (mode == 0) {
			text("Status: " + statusText, 0, 20);
			text("Side: " + currentSide, 0, 40);
			text("Charge: " + charge, 0, 60);
			text("Vibration: " + vibValue, 0, 80);
		}
		
		text("Light: ", 0, 100);
		ellipseMode(CENTER);
		fill(rgb[0], rgb[1], rgb[2], luminance);
		ellipse(55, 97, 10, 10);
		popMatrix();
		
	}
	
}