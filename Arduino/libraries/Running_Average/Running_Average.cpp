//
//
// Running_Average.cpp
//
// The library stores the last N individual values in a circular buffer,
// to calculate the running average.
//

#include "Running_Average.h"
#include <stdlib.h>

// Constructor function
Running_Average::Running_Average(int winSize){
	_size = winSize;
	_arr = (float*) malloc(_size * sizeof(float)); // Allocate memory for array (_arr is pointer to the array)
	if (_arr == NULL){ _size = 0; }
	clear();
}

// Destructor function
Running_Average::~Running_Average(){
    if (_arr != NULL) { free(_arr); }
}

// Reset counters
void Running_Average::clear(){
    _count = 0;
    _idx = 0;
    _sum = 0.0;
    for (int i = 0; i< _size; i++) { _arr[i] = 0; }  // Fill array with zeros
}

// Subtract an integer value from entire array
void Running_Average::decrement(int inputNum){
	for (int i = 0; i< _size; i++) { _arr[i] -= inputNum; }
}

// Add a new value to the array
void Running_Average::addValue(float inputValue){
    if (_arr == NULL) return;  			// Abort if array is invalid
    _sum -= _arr[_idx];       			// Subtract last reading from the total
    _arr[_idx] = inputValue;  			// Add newest value to array       
    _sum += _arr[_idx];		  			// Add the new value to the total
    _idx++; 				  			// Move index to next value
    if (_idx == _size) { _idx = 0; } 	// If index is at end of array, wrap back to beginning
    if (_count < _size) { _count++; }   // Tracks how many values are in the array if it's not full yet
}

// Calculate and return current average of the array
float Running_Average::getAvg(){
	if (_count == 0) { return NAN; }
	return _sum / _count; 
}






























