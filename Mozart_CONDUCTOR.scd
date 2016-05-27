// CONDUCTOR

// Load IPs
"Mozart_IP_Addresses.scd".loadRelative;

// Load some variables
"Mozart_Init_Variables.scd".loadRelative;

// Load some functions
"Mozart_Conductor_Functions.scd".loadRelative;

// Load GUI
"Mozart_Conductor_GUI.scd".loadRelative;






// ================================================



// we no longer need to run the code below manually
// it's all in the GUI

// Start metronome
// ~sendTempoStart.value(120);

// Change tempo anytime
// ~sendTempoChange.value(191);

// Start playing
// ~sendStartPlaying.value;

// Start playing
// ~sendStopPlaying.value;

// Print tally updates
(
f = {
	inf.do{
		~tally.postln;
		~referendumTally.postln;
		0.9.wait;
	}
}.fork;
)
f.stop

// Still MANUAL...
// findWinner, instantly send it to all computers, reset list
// ~findWinner.value;

// ~startReferendum.value(4);

// ~findReferendumWinner.value;


// probably no need for this
// default set to 0
// Who advances letter measures? 0 = conductor does; 1 = local machines do.
// ~advanceLetterMeasureFlag.value(1);








// Manually send winners (1-12)
~sendDiceWinner.value(rrand(2, 12));

~tally;



// idea for another version:
// vote only gets counted when we reach a minimum number of voters
// make players be stuck on SAME measure A, B, C... until that happens.


