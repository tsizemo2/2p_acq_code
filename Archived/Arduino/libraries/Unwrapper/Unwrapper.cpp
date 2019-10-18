//
//
// Unwrapper.cpp
//
// Unwraps looped data (e.g. 0-2*pi phase data or wrapped analog input 0-10V data) 
//
//

#include "Unwrapper.h"
#include <stdlib.h>

// Constructor function
Unwrapper::Unwrapper(int jumpTol, int range)
{
	_range = range;
	_jumpTol = jumpTol;
	_oldValue = -1; // Start at -1 to indicate that first input has not been assigned
	_wrapCount = 0;
}

// Unwrap a new value and update old value and wrapCount
long Unwrapper::unwrap(int inputValue)
{
	// Reset count if it's about to exceed long integer size
	if (abs(inputValue) > 2147000000)
	{
		_oldValue = -1;
	}
	
	// Unwrapping
	if (_oldValue > -1)
	{
			if (abs(inputValue - _oldValue) > _jumpTol)
			{
				if (inputValue < _oldValue)
				{
					_wrapCount += 1;
					_oldValue = inputValue;
					return (long)(inputValue + (_range * _wrapCount));
				}else
				{
					_wrapCount -= 1;
					_oldValue = inputValue;
					return (long)(inputValue + (_range * _wrapCount));
				}
			}else
			{
				return (long)inputValue;
			}
	}else 
	{
		// If this is the first input value, just save it
		_oldValue = inputValue;
	    return inputValue;
	}
}
