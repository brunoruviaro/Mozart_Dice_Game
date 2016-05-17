// CONDUCTOR

// Load IPs
"Mozart_IP_Addresses.scd".loadRelative;

// Load some functions
"Mozart_Conductor_Functions.scd".loadRelative;

// Start metronome
~sendTempoStart.value(120);

// Change tempo anytime
~sendTempoChange.value(141);

// Start playing
~sendStartPlaying.value;

// Print tally updates
(
{
	inf.do{
		~tally.postln;
		0.3.wait;
	}
}.fork;
)

// Still MANUAL...
// findWinner, instantly send it to all computers, reset list
~findWinner.value;








// Manually send winners (1-12)
~sendDiceWinner.value(10);

~tally;



// idea for another version:
// vote only gets counted when we reach a minimum number of voters
// make players be stuck on SAME measure A, B, C... until that happens.


