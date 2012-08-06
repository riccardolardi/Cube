public class Checker {
	
	Checker() {
		
		// nuthin'
		
	}
	
	void check() {
		
		if (mode == 0) {
		
			if (shaking == true) {
			
				smoothShake.add(abs(float(dakaX.accelX())));
				smoothShake.add(abs(float(dakaX.accelY())));
				smoothShake.add(abs(float(dakaX.accelZ())));
			
				checkShake();
			
			}
		
			if (splashing == true) {
			
				smoothSplash.add(abs(float(dakaX.accelX())));
				smoothSplash.add(abs(float(dakaX.accelY())));
				smoothSplash.add(abs(float(dakaX.accelZ())));
			
				checkSplash();
			
			}
		
			if (status == 3) {
			
				checkStep();
				checkSide();
			
				if (turning == true) {
					checkTurn();
				}
			
				checkFinish();
			
			}
		
		} else if (mode == 1) {
			
			checkSide();
			
		} else if (mode == 2) {
			
			checkSide();
			checkTurn();
			
		}
		
	}
	
	void checkShake() {
		
		if (smoothShake.read() > 5000) {
			charge = charge + chargeAmount;
		}
		
	}
	
	void checkSplash() {
		
		for (int i = 0; i < smoothSplash.values.length; i++) {
			if (smoothSplash.values[i] > 25000) {
				splashed = true;
			}
		}
		
	}
	
	void checkStep() {
		
		Integer nextStep = (Integer) stepSequence.get(currentStep);
		
		if ((nextStep <= 5) && (tilting == false)) {
			tilting = true;
		}
		
		if ((nextStep == 6) && (turning == false)) {
			getNormal();
			turnDir = 0;
			turning = true;
		} else if ((nextStep == 7) && (turning == false)) {
			getNormal();
			turnDir = 1;
			turning = true;
		}
		
	}
	
	void checkSide() {
		
		if (smoothZ.read() > 6500) {
			if (currentSide != 0) {
				changeSide(0);
			}
		}
		
		if (smoothZ.read() < -7000) {
			if (currentSide != 1) {
				changeSide(1);
			}
		}
		
		if (smoothY.read() > 7000) {
			if (currentSide != 2) {
				changeSide(2);
			}
		}
		
		if (smoothY.read() < -7000) {
			if (currentSide != 3) {
				changeSide(3);
			}
		}
		
		if (smoothX.read() > 7000) {
			if (currentSide != 4) {
				changeSide(4);
			}
		}
		
		if (smoothX.read() < -7000) {
			if (currentSide != 5) {
				changeSide(5);
			}
		}
		
	}
	
	void changeSide(int newSide) {
		
		oldSide = currentSide;
		currentSide = newSide;
		
		clearSmoothers();
		
		// DEBUG
		message("changed to Side "+newSide, false);
		
		if (mode == 0) {
		
			Integer tmp = (Integer) stepSequence.get(currentStep);
		
			if (tmp == currentSide) {
			
				// tilted correctly
				lightControl.randomLight();
				tilting = false;
				currentStep++;
				message("tilted correctly!", true);
				message("step "+currentStep+" completed!", false);
			
			} else {
				
				goToSleep();
				
			}
		
		} else if (mode == 1) {
			
			rgb[0] = int(random(100, 255));
			rgb[1] = int(random(100, 255));
			rgb[2] = int(random(100, 255));
			
		} else if (mode == 2) {
			
			getNormal();
			
		}
		
	}
	
	void checkTurn() {
	
		rotMatrix.mult(dirNormal, vecWCEnd);
	
		float tmpAngle = PVector.angleBetween(vecWCStart, vecWCEnd);
		PVector tmpCross = new PVector();
		tmpCross = vecWCStart.cross(vecWCEnd);
		tmpCross.normalize();
		
		// DEBUG
		// message("heading diff: " + degrees(tmpAngle) + " cross: " + tmpCross, false);
		
		if (mode == 0) {
		
			if (turnDir == 0) {
			
				if (tmpCross.y < 0.0) {
				
					turnVib = map(tmpAngle, 0.0, 2.0, 0, 255);
				
					// DEBUG
					// message("wrong turn " + tmpAngle + " vib " + turnVib, false);
				
				} else {
				
					turnVib = 0.0;
				
				}
			
				if ((degrees(tmpAngle) >= 90) && (tmpCross.y > 0.0)) {
					lightControl.randomLight();
					message("turned correctly!", true);
					turning = false;
					currentStep++;
					message("step "+currentStep+" completed!", false);
				}
			
			}
		
			if (turnDir == 1) {
			
				if (tmpCross.y > 0.0) {
				
					turnVib = map(tmpAngle, 0.0, 2.0, 0, 255);
				
					// DEBUG
					// message("wrong turn " + tmpAngle + " vib " + turnVib, false);
				
				} else {
				
					turnVib = 0.0;
				
				}
			
				if ((degrees(tmpAngle) >= 90) && (tmpCross.y < 0.0)) {
					lightControl.randomLight();
					message("turned correctly!", true);
					turning = false;
					currentStep++;
					message("step "+currentStep+" completed!", false);
				}
			
			}
		
		} else if (mode == 2) {
			
			rgb[0] = int(map(tmpAngle, 0.0, 2.0, 0, 255));
			rgb[1] = int(map(tmpAngle, 0.0, 2.0, 255, 0));
			rgb[2] = 0;
			
			// DEBUG
			// message(rgb[0] + " " + rgb[1] + " " + rgb[2], 0);
			
		}
		
	}
	
	void getNormal() {
		
		switch (currentSide) {
			
			case 0:
			dirNormal = new PVector(0,0,100);
			rotMatrix.mult(dirNormal, vecWCStart);
			break;
			
			case 1:
			dirNormal = new PVector(0,0,100);
			rotMatrix.mult(dirNormal, vecWCStart);
			break;
			
			case 2:
			dirNormal = new PVector(0,100,0);
			rotMatrix.mult(dirNormal, vecWCStart);
			break;
			
			case 3:
			dirNormal = new PVector(0,100,0);
			rotMatrix.mult(dirNormal, vecWCStart);
			break;
			
			case 4:
			dirNormal = new PVector(0,100,0);
			rotMatrix.mult(dirNormal, vecWCStart);
			break;
			
			case 5:
			dirNormal = new PVector(0,100,0);
			rotMatrix.mult(dirNormal, vecWCStart);
			break;
			
		}
		
	}
	
	void checkFinish() {
		
		if (currentStep == stepSequence.size()) {
			
			message("LEVEL COMPLETE! Creating new level:", false);
			
			charge();
			
			levelSize++;
			currentStep = 0;
			level = new Level();
			
		}
		
	}
		
}