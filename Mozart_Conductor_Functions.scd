// MOZART DICE GAME "CONDUCTOR"
// FUNCTIONS

// function to start tempoclock on everyone
~sendTempoStart = { arg bpm;
	~ips.do({ arg item;
		item.sendMsg("/tempo/start", bpm)
	});
};

// function to change tempo on everyone
~sendTempoChange = { arg bpm;
	~ips.do({ arg item;
		item.sendMsg("/tempo/change", bpm)
	});
};

// function to send start trigger to everyone
~sendStartPlaying = { ~ips.do({ arg item; item.sendMsg("/start", "go") }) };

// function to send STOP signal to everyone
~sendStopPlaying = { ~ips.do({ arg item; item.sendMsg("/stop", "STOP") }) };

// function to send "dice" winner candidate to everyone
~sendDiceWinner = { arg diceWinner; ~ips.do({ arg item; item.sendMsg("/diceWinner", diceWinner)}) };

// send referendum winner (yes 1, no 0) to everyone
// no need to send referendum topic again, as that info
// will have been defined
// locally on player machines at referendum start
~sendReferendumWinner = { arg referendumWinner; ~ips.do({ arg item; item.sendMsg("/referendumWinner", referendumWinner)}) };

// start Referendum
~startReferendum = { arg referendumCode; ~ips.do({ arg item; item.sendMsg("/startReferendum", referendumCode)}) };

// end referendum
~endReferendum = { ~ips.do({ arg item; item.sendMsg("/endReferendum")}) };

// start referendum should set a variable indicating ref type (anarchy, slower, faster, transpose, etc).
// end referendum should call a function to tally Y/N votes, and act upon results calling another function to make it happen.

// function to tell players to either ADVANCE (1) or NOT ADVANCE (0) letter measures locally.
~advanceLetterMeasureFlag = { arg flag = 0; ~ips.do({ arg item; item.sendMsg("/letterMeasureFlag", flag)}) };



// =============================
// VOTING SYSTEM (regular votes)
// (candidates 1-12, "dice" game)
// =============================

// number of candidates
~numberOfCandidates = 13;

// create an empty tally array
~tally = Array.fill(~numberOfCandidates, 0);


// get votes from orchestra
OSCdef(
	key: \getVotes,
	func: { arg msg;
		var candidate = msg[1];
		var currentCount = ~tally[candidate];
		// candidate.postln;
		// currentCount.postln;
		~tally[candidate] = currentCount + 1;
	},
	path: '/vote';
).permanent_(true);


// find Winner Candidate ("dice result")
// and send it out right away
~findWinner = {
	var diceWinner = ~tally.maxIndex; // find winner
	["winner is ", diceWinner].postln;
	~tally = Array.fill(~numberOfCandidates, 0); // new array
	~tally.postln;
	~sendDiceWinner.value(diceWinner); // send it out
	// if protest vote, turn flashing sign on
	if(diceWinner==1,
		{
			~protestSignAlert.value(1);
		},
		{
			~protestSignAlert.value(0);
		}
	);
};

// =======================================
// REFERENDUM SYSTEM (separate y/n votes)
// only happens occasionally.
// =======================================

// create an empty tally array
~referendumTally = Array.fill(2, 0); // just 2 candidates, yes (1) or no (0)


// get referendum votes from orchestra
// 0 means no, 1 means yes
OSCdef(
	key: \getReferendumVotes,
	func: { arg msg;
		var yesOrNo = msg[1];
		var currentCount = ~referendumTally[yesOrNo];
		// candidate.postln;
		// currentCount.postln;
		~referendumTally[yesOrNo] = currentCount + 1;
	},
	path: '/referendumVote';
).permanent_(true);


// find referendum result: YES or NO?
// and send it out right away
~findReferendumWinner = {
	var referendumWinner = ~referendumTally.maxIndex; // find winner
	["referendum winner is ", referendumWinner].postln;
	~referendumTally = Array.fill(2, 0); // new array
	~referendumTally.postln;
	~endReferendum.value; // send end message to all
	~sendReferendumWinner.value(referendumWinner); // send it out
};

// =======================================
// ALERT SYSTEM
// display flashing signs for Protest Vote
// and SuperDelegate Mode
// =======================================

// get superdelegate warning from players
OSCdef(
	key: \superdelegate,
	func: { arg msg;
		var flag = msg[1]; // 0 = off, 1 = on
		~superdelegateAlert.value(flag);
	},
	path: '/superD';
).permanent_(true);

// NOTE: "Protest Vote" sign is turned on and off directly inside "findWinner" function.
