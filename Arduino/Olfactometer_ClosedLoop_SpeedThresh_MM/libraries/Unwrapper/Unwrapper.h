#ifndef Unwrapper_h
#define Unwrapper_h

#include "Arduino.h"

class Unwrapper
{
	public:
		Unwrapper(int jumpTol, int range);
	    long unwrap(int inputValue);
		int getWrapCount() { return _wrapCount; }

	private:
		int _wrapCount;		
		long _oldValue;
		int _range;
		int _jumpTol;
};
#endif	