public class LightControl {
	
	int last_time;
	int lastCheck = 0;
	boolean goingUp = true;
	boolean soundPlaying = false;
	
	LightControl() {
		
		// nuthin'
		
	}
	
	void lighten() {
		
		if (mode == 0) {
		
			switch (status) {
			
				case 0:
				luminance = pow(charge, 3)/255/255;
				rgb[0] = 0;
				rgb[1] = 0;
				rgb[2] = int(charge);
				break;
			
				case 1:
				luminance = 255;
				rgb[0] = 0;
				rgb[1] = 255;
				rgb[2] = 255;
				break;
			
				case 2:
			
				rgb[0] = 0;
				rgb[1] = 255;
				rgb[2] = 255;
			
				if (luminance >= 255.0) {
					goingUp = false;
				} else if (luminance <= 0.0) {
					goingUp = true;
				}
			
				if (goingUp == true) {
					luminance = luminance + 3;
				} else if (goingUp == false) {
					luminance = luminance - 3;
				}
			
				break;
			
				case 3:
			
				if (turning == true) {
					rgb[0] = 255;
					rgb[1] = 0;
					rgb[2] = 0;
				} else {
					rgb[0] = 0;
					rgb[1] = 255;
					rgb[2] = 0;
				}
			
				luminance = pow(charge, 3)/255/255;
			
				break;			
			
			}
		
		}
		
		sendToDaka(CMD_SET_LIGHT, 20, rgb);
		
	}
	
	void randomLight() {
		
		random = true;
		
		for (int i = 0; i < 10; i++) {
			
			float lastmillis = millis();			
			int choice = int(random(4));
			int lastchoice = choice;
			
			while (choice == lastchoice) {
				choice = int(random(4));
			}
			
			switch (choice) {
				
				case 0:
				rgb[0] = 255;
				rgb[1] = 255;
				rgb[2] = 0;
				break;
				
				case 1:
				rgb[0] = 255;
				rgb[1] = 150;
				rgb[2] = 0;
				break;
				
				case 2:
				rgb[0] = 0;
				rgb[1] = 255;
				rgb[2] = 150;
				break;
				
				case 3:
				rgb[0] = 0;
				rgb[1] = 150;
				rgb[2] = 255;
				break;
				
				case 4:
				rgb[0] = 255;
				rgb[1] = 0;
				rgb[2] = 255;
				break;
				
			}
			
			// DEBUG
			// message("random color " + rgb[0] + " " + rgb[1] + " " + rgb[2], false);
			
			while (millis() < lastmillis + 100) {
				
				sendToDaka(CMD_SET_LIGHT, 20, rgb);
				
			}
			
		}
		
		random = false;
		
	}
	
	void sendToDaka(int packet, int frequency, int[] _rgb) {
		
		if ((mode == 0) && (random == false) && (goingToSleep == false)) {
		
			if (_rgb[0] > 0) {
				_rgb[0] = int(luminance);
			}
		
			if (_rgb[1] > 0) {
				_rgb[1] = int(luminance);
			}
		
			if (_rgb[2] > 0) {
				_rgb[2] = int(luminance);
			}
		
		}

		if (frequency < millis() - last_time) {

			dakaX.serialCom().beginSend(packet);
			dakaX.serialCom().sendByte(_rgb[0]);
			dakaX.serialCom().sendByte(_rgb[1]);
			dakaX.serialCom().sendByte(_rgb[2]);
			dakaX.serialCom().endSend();

			last_time = millis();

			// DEBUG
			// println("sending light to " + packet + " value: " + _rgb[0] + " " + _rgb[1] + " " + _rgb[2] + " every " + frequency + " millis ");
		
		}
		
	}
	
}