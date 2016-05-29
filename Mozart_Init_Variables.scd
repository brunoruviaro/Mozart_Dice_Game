// ==============
// INIT VARIABLES
// ==============

~bpm = 180; //
~winner = 3; // dice results
~part = 1; // part I or part II of the piece
~moveToNextPartFlag = 0; // keeps track of when to move to next part
~letterMeasure = 0; // 0-7 columns from Number Tables (A, B, C, D, E, F, G, H)
~letterMeasureFlag = 0; // convenience tool for debugging ('who advances measures - conductor or local?')
~transpRH = 0; // transposition in semitones for right hand
~transpLH = 0; // transposition in semitones for left hand
~ampScaleRH = 1; // scaling factor for right hand amplitude (per note)
~ampScaleLH = 1; // scaling factor for left hand amplitude (per note)
~currentReferendum = 0;
// referendum options below:
~referendumArray = [
	/* 0 */ "faster?",
	/* 1 */ "slower?",
	/* 2 */ "transpose pretty?",
	/* 3 */ "transpose prettier?",
	/* 4 */ "make mozart great again?",
	/* 5 */ "lesser evil?"
];