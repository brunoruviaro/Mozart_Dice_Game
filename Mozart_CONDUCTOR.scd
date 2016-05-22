// CONDUCTOR

// Load IPs
"Mozart_IP_Addresses.scd".loadRelative;

// Load some functions
"Mozart_Conductor_Functions.scd".loadRelative;

// Start metronome
~sendTempoStart.value(120);

// Change tempo anytime
~sendTempoChange.value(91);

// Start playing
~sendStartPlaying.value;

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
~findWinner.value;

~startReferendum.value(0);

~findReferendumWinner.value;


// probably no need for this
// default set to 0
// Who advances letter measures? 0 = conductor does; 1 = local machines do.
// ~advanceLetterMeasureFlag.value(0);








// Manually send winners (1-12)
~sendDiceWinner.value(rrand(2, 12));

~tally;



// idea for another version:
// vote only gets counted when we reach a minimum number of voters
// make players be stuck on SAME measure A, B, C... until that happens.


