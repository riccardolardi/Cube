/*

CUBE
v0.5

ZHdK 2011
IxD Bachelor Project

Sibylle Oeschger, Daniel Schmider, Markus Kerschkewicz, Riccardo Lardi

*/

// imports
import iadZhdk.dakaX.*;
import processing.serial.*;
import processing.opengl.*;

// settings
float chargeAmount = 0.75;
float dischargeAmount = 0.05;
float levelUpChargeAmount = 50;
int levelSize = 3;

// test sketches
boolean testVib = false;

// modes
// 0 = normal
// 1 = amateur 1
// 2 = amateur 2
int mode = 0;

// objects
DakaX dakaX;
Smoother smoothX, smoothY, smoothZ, smoothShake, smoothSplash;
Checker checker;
Level level;
Monitor monitor;
VibraControl vibraControl;
LightControl lightControl;

// flags
boolean shaking = false;
boolean splashing = false;
boolean splashed = false;
boolean tilting = false;
boolean turning = false;
boolean random = false;
boolean goingToSleep = false;

// status
int status = 0;
float charge = 0;

// turn direction
// 0 = left
// 1 = right
int turnDir = 0;

// sides
int currentSide = 99;
int oldSide = 99;
int badSide;

// vectors
PVector dirNormal = new PVector();
PVector dir = new PVector();
PVector vecWCStart = new PVector(0,0,0);
PVector vecWCEnd = new PVector(0,0,0);

// rotation matrix
PMatrix3D rotMatrix = new PMatrix3D();

// level stuff
ArrayList stepSequence;
int currentStep;

// vibration
float tmpVib = 0.0;
float turnVib = 0.0;
boolean movingCorrect = false;
boolean wrongSide = false;

// light
int[] rgb = {0, 0, 255};
float luminance = 0.0;

// daka messages
final static int CMD_SET_VIB = DakaX.DAKAX_MSG_ID_USER + 1;
final static int CMD_SET_LIGHT = DakaX.DAKAX_MSG_ID_USER + 2;

void setup() {
	
	size(200, 200, OPENGL);
	noStroke();
	smooth();
	
	// setup daka
	String portName;
	String os = System.getProperty("os.name").toLowerCase();
	
	if(os.indexOf( "nix") >=0 || os.indexOf( "nux") >=0) {
		portName = "/dev/rfcomm0"; 
	} else if(os.indexOf("mac") >= 0) {  // mac
		portName = "/dev/tty.dakaCube-DevB";
	} else {
		portName = "COM9"; 
	}

	println("Open SerialPort: " + portName);
	dakaX = new DakaX(this, portName, 230400);

	if(dakaX.isOpen() == false) {
		
		println("Can't open SerialPort!");
		exit();
		
	} else {

		// create monitor
		monitor = new Monitor();
		
		// create vib & light control
		vibraControl = new VibraControl();
		lightControl = new LightControl();

		// create smoothers
		smoothX = new Smoother(100);
		smoothY = new Smoother(100);
		smoothZ = new Smoother(100);
		smoothShake = new Smoother(100);
		smoothSplash = new Smoother(100);
		
		// create checker
		checker = new Checker();
	
		// start application
		message("\nWELCOME TO CUBE!\n", false);
	
	}
	
	if (mode == 1) {
		luminance = 255;
	} else if (mode == 2) {
		luminance = 255;
		turning = true;
	}

}

void draw() {
	
	// background
	background(235);
	
	// update the daka
	dakaX.update();
	dakaX.getRotMatrix(rotMatrix);
	rotMatrix.mult(dirNormal, dir);

	// add daka values to smoothers
	smoothX.add(float(dakaX.accelX()));
	smoothY.add(float(dakaX.accelY()));
	smoothZ.add(float(dakaX.accelZ()));
	
	if (testVib == true) {

		int tmpVibTest = 255;
		message("testing vibration with " + tmpVibTest, false);
		vibraControl.sendToDaka(CMD_SET_VIB, 100, tmpVibTest);
	
	} else {
		
		checker.check();
		statusCheck();
		monitor.display();
		
	}
	
	lightControl.lighten();
	
}

void statusCheck() {
	
	if (mode == 0) {
	
		switch (status) {
		
			case 0: // sleeping
			loadCube();
			break;
		
			case 1: // initialize
			initialize();
			break;
		
			case 2: // ready
			splashCube();
			break;
		
			case 3: // game
			discharge();
			vibraControl.vibrate();
			break;
		
		}
	
	}
	
}

void loadCube() {
	
	if (charge < 255) {
		shaking = true;
	} else {
		clearSmoothers();
		shaking = false;
		charge = 255;
		status = 1;
	}
	
}

void initialize() {
	
	boolean sideCalib = false;
	
	if (smoothZ.read() > 6500) {
		currentSide = 0;
		sideCalib = true;
		dirNormal = new PVector(0,0,100);
	  	rotMatrix.mult(dirNormal, vecWCStart);
	} else if (smoothZ.read() < -7000) {
		currentSide = 1;
		sideCalib = true;
		dirNormal = new PVector(0,0,100);
	  	rotMatrix.mult(dirNormal, vecWCStart);
	} else if (smoothY.read() > 7000) {
		currentSide = 2;
		sideCalib = true;
		dirNormal = new PVector(0,100,0);
	  	rotMatrix.mult(dirNormal, vecWCStart);
	} else if (smoothY.read() < -7000) {
		currentSide = 3;
		sideCalib = true;
		dirNormal = new PVector(0,100,0);
		rotMatrix.mult(dirNormal, vecWCStart);
	} else if (smoothX.read() > 7000) {
		currentSide = 4;
		sideCalib = true;
		dirNormal = new PVector(0,100,0);
	  	rotMatrix.mult(dirNormal, vecWCStart);
	} else if (smoothX.read() < -7000) {
		currentSide = 5;
		sideCalib = true;
		dirNormal = new PVector(0,100,0);
	  	rotMatrix.mult(dirNormal, vecWCStart);
	}
	
	if (sideCalib == true) {
		clearSmoothers();
		sideCalib = false;
		status = 2;
	}
	
}

void splashCube() {
	
	if (splashed == false) {
		
		splashing = true;
		
	} else {
		
		clearSmoothers();
		splashed = false;
		splashing = false;
		
		// create new level
		currentStep = 0;
		level = new Level();
		
		lightControl.randomLight();
		
		status = 3;
		
	}
	
}

void charge() {
	
	charge = charge + levelUpChargeAmount;
	if (charge > 255) {
		charge = 255;
	}
	
}

void discharge() {
	
	if (charge > 0) { 
		charge = charge - dischargeAmount;
	}
	
	if (charge < 30) {
		goToSleep();
	}
	
}

void goToSleep() {
	
	boolean goingUp = false;
	boolean goingDown = false;
	float lastmillis = millis();
	
	goingToSleep = true;
	
	clearSmoothers();
	
	vibraControl.sendToDaka(CMD_SET_VIB, 20, 0);
	
	turning = false;
	shaking = false;
	splashing = false;
	
	charge = 0;
	status = 0;
	
	// DEBUG
	message("oh no... game over. sorry!", true);
	
	rgb[0] = 0;
	rgb[1] = 0;
	rgb[2] = 0;
	
	while (millis() < lastmillis + 3000) {
	
		if (rgb[0] >= 255.0) {
			goingUp = false;
		} else if (rgb[0] <= 0.0) {
			goingUp = true;
		}
	
		if (goingUp == true) {
			rgb[0] = rgb[0] + 3;
		} else if (goingUp == false) {
			rgb[0] = rgb[0] - 3;
		}
		
		// DEBUG
		// message("going to sleep " + rgb[0], false);
		lightControl.sendToDaka(CMD_SET_LIGHT, 20, rgb);
	
	}
	
	rgb[0] = 0;	
	lightControl.sendToDaka(CMD_SET_LIGHT, 20, rgb);
	
	goingToSleep = false;
	
}

void clearSmoothers() {
	
	// clear all smoother values
	smoothX.clear();
	smoothY.clear();
	smoothZ.clear();
	smoothShake.clear();
	smoothSplash.clear();
	
}

void message(String _msg, boolean _say) {
	
	// custom message system
	if (_say == true) {
		String[] params = {"say", "'"+_msg+"'"};
		exec(params);
	}
	
	println(_msg);
	
}