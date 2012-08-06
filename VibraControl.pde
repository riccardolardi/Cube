public class VibraControl {
	
	float val1 = 0.0;
	float val2 = 0.0;
	
	VibraControl() {
		
		// nuthin'
		
	}
	
	void vibrate() {
		
		// if tilting...
		if (turning == false) {
		
			Integer nextSide = (Integer) stepSequence.get(currentStep);
		
			movingCorrect = false;
		
			switch (currentSide) {
			
				case 0:
				// x, y
				// sides 4, 3, 5, 2
				val1 = smoothX.read();
				val2 = smoothY.read();
				if ((nextSide == 4) && (abs(val1) > abs(val2)) && (val1 > 0)) {
					movingCorrect = true;
				} else if ((nextSide == 3) && (abs(val2) > abs(val1)) && (val2 < 0)) {
					movingCorrect = true;
				} else if ((nextSide == 5) && (abs(val1) > abs(val2)) && (val1 < 0)) {
					movingCorrect = true;
				}	else if ((nextSide == 2) && (abs(val2) > abs(val1)) && (val2 > 0)) {
					movingCorrect = true;
				}
				break;
			
				case 1:
				// x, y
				// sides 4, 3, 5, 2
				val1 = smoothX.read();
				val2 = smoothY.read();
				if ((nextSide == 4) && (abs(val1) > abs(val2)) && (val1 > 0)) {
					movingCorrect = true;
				} else if ((nextSide == 3) && (abs(val2) > abs(val1)) && (val2 < 0)) {
					movingCorrect = true;
				} else if ((nextSide == 5) && (abs(val1) > abs(val2)) && (val1 < 0)) {
					movingCorrect = true;
				}	else if ((nextSide == 2) && (abs(val2) > abs(val1)) && (val2 > 0)) {
					movingCorrect = true;
				}
				break;
			
				case 2:
				// x, z
				// sides 4, 1, 5, 0
				val1 = smoothX.read();
				val2 = smoothZ.read();
				if ((nextSide == 4) && (abs(val1) > abs(val2)) && (val1 > 0)) {
					movingCorrect = true;
				} else if ((nextSide == 1) && (abs(val2) > abs(val1)) && (val2 < 0)) {
					movingCorrect = true;
				} else if ((nextSide == 5) && (abs(val1) > abs(val2)) && (val1 < 0)) {
					movingCorrect = true;
				}	else if ((nextSide == 0) && (abs(val2) > abs(val1)) && (val2 > 0)) {
					movingCorrect = true;
				}
				break;
			
				case 3:
				// x, z
				// sides 4, 1, 5, 0
				val1 = smoothX.read();
				val2 = smoothZ.read();
				if ((nextSide == 4) && (abs(val1) > abs(val2)) && (val1 > 0)) {
					movingCorrect = true;
				} else if ((nextSide == 1) && (abs(val2) > abs(val1)) && (val2 < 0)) {
					movingCorrect = true;
				} else if ((nextSide == 5) && (abs(val1) > abs(val2)) && (val1 < 0)) {
					movingCorrect = true;
				}	else if ((nextSide == 0) && (abs(val2) > abs(val1)) && (val2 > 0)) {
					movingCorrect = true;
				}
				break;
			
				case 4:
				// y, z
				// sides 2, 1, 3, 0
				val1 = smoothY.read();
				val2 = smoothZ.read();
				if ((nextSide == 2) && (abs(val1) > abs(val2)) && (val1 > 0)) {
					movingCorrect = true;
				} else if ((nextSide == 1) && (abs(val2) > abs(val1)) && (val2 < 0)) {
					movingCorrect = true;
				} else if ((nextSide == 3) && (abs(val1) > abs(val2)) && (val1 < 0)) {
					movingCorrect = true;
				}	else if ((nextSide == 0) && (abs(val2) > abs(val1)) && (val2 > 0)) {
					movingCorrect = true;
				}
				break;
			
				case 5:
				// y, z
				// sides 2, 1, 3, 0
				val1 = smoothY.read();
				val2 = smoothZ.read();
				if ((nextSide == 2) && (abs(val1) > abs(val2)) && (val1 > 0)) {
					movingCorrect = true;
				} else if ((nextSide == 1) && (abs(val2) > abs(val1)) && (val2 < 0)) {
					movingCorrect = true;
				} else if ((nextSide == 3) && (abs(val1) > abs(val2)) && (val1 < 0)) {
					movingCorrect = true;
				}	else if ((nextSide == 0) && (abs(val2) > abs(val1)) && (val2 > 0)) {
					movingCorrect = true;
				}
				break;			
			
			}
		
			tmpVib = max(abs(val1), abs(val2));
		
			if (movingCorrect == false) {
				// DEBUG
				// message("vibrate "+map(tmpVib, 0.0, 1.0, 0, 255), false);
				sendToDaka(CMD_SET_VIB, 20, int(map(tmpVib, 0.0, 7000.0, 0, 255)));
			} else {
				sendToDaka(CMD_SET_VIB, 20, 0);
			}
		
		} else if (turning == true) {
			
			sendToDaka(CMD_SET_VIB, 20, int(turnVib));
			
		}
		
	}
	
	void sendToDaka(int pin, int frequency, int value) {
		
		float last_time = 0.0;

	  	if (frequency < millis() - last_time) {

	    	dakaX.serialCom().beginSend(pin);
	    	dakaX.serialCom().sendByte(value);
	    	dakaX.serialCom().endSend();

	    	last_time = millis();

	    	// DEBUG
	    	// println("sending to " + pin + " value: " + value + " every " + frequency + " millis ");
			monitor.vibValue = value;

	  	}
	
	}
	
}