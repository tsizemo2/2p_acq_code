#ifndef running_average_h
#define running_average_h

#include "Arduino.h"

class Running_Average
{
	public:
		Running_Average(int);
		~Running_Average();
		
		void clear();
		void addValue(float);
		void decrement(int inputNum);
		float getAvg();
		uint8_t getSize() { return _size; }
		uint8_t getCount() { return _count; }
	
	private:
		uint8_t _size;
		uint8_t _count;
		uint8_t _idx;
		float _sum;
		float * _arr;
};
#endif	