public class Level {

	Level() {
	
		stepSequence = new ArrayList();
		generateSequence();
	
	}
	
	void generateSequence() {

		findBadSide(currentSide);

		int tmpNewValue = round(random(7));
		
		while ((tmpNewValue == currentSide) || (tmpNewValue == badSide)) {
			
			tmpNewValue = round(random(7));
			
		}
		
		stepSequence.add(tmpNewValue);
		
		for (int i = 0; i < levelSize - 1; i++) {
			
			tmpNewValue = round(random(7));
			
			Integer lastValue = (Integer) stepSequence.get(i);
			
			findBadSide(lastValue);
			
			while ((tmpNewValue == currentSide) || (tmpNewValue == lastValue) || (tmpNewValue == badSide)) {
				
				tmpNewValue = round(random(7));
				
			}
			
			stepSequence.add(tmpNewValue);
			
		}
		
		String tmpMsg;
		tmpMsg = "starting with sequence:";
		for (int i = 0; i < levelSize; i++) {
			Integer tmpStep = (Integer) stepSequence.get(i);
			if (tmpStep <= 5) {
				tmpMsg = tmpMsg.concat(" tilt to "+tmpStep);
			} else if (tmpStep == 6) {
				tmpMsg = tmpMsg.concat(" turn left");
			} else if (tmpStep == 7) {
				tmpMsg = tmpMsg.concat(" turn right");
			} else if (tmpStep == 8) {
				tmpMsg = tmpMsg.concat(" shake");
			} else if (tmpStep == 9) {
				tmpMsg = tmpMsg.concat(" splash");
			}
			if (i != levelSize - 1) {
				tmpMsg = tmpMsg.concat(",");
			}
		}
		
		message(tmpMsg, false);
		
	}
	
	void findBadSide(int checkSide) {
		
		switch (checkSide) {
			
			case 0:
			badSide = 1;
			break;
			
			case 1:
			badSide = 0;
			break;
			
			case 2:
			badSide = 3;
			break;
			
			case 3:
			badSide = 2;
			break;
			
			case 4:
			badSide = 5;
			break;
			
			case 5:
			badSide = 4;
			break;
			
		}
		
	}

}