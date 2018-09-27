#ifndef Unwrapper_h
#define Unwrapper_h

#include "Arduino.h"

class Unwrapper
{
	public:
		Unwrapper(int jumpTol, int range);
	    long unwrap(int inputValue);
		int getWrapCount() { return _wrapCount; }
		int get100kCount() { return _100kCount;}
	private:
		int _wrapCount;		
		int _wrapCount100;
		long _oldValue;
		int _range;
		int _jumpTol;
};
#endif	