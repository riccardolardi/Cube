class Smoother {
	
	float[] values;
	
	Smoother(int length) {
		
		values = new float[length];
		
		for (int i = 0; i < values.length; i++) {
			values[i] = 0.0;
    }

	}
	
	void add(float value) {
		
		for (int i = 0; i < (values.length - 1); i++) {
			values[i] = values[i + 1];
    }
		
		values[values.length - 1] = value;
	}
	
	float read() {
		
		float value = 0;
		
		for (int i = 0; i < values.length; i++) {
			value += values[i];
    }

		value /= values.length;
		return value;
		
	}
	
	void clear() {
		
		for (int i = 0; i < values.length; i++) {
			values[i] = 0;
    }
		
	}
	
}