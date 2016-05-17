// MOZART DICE GAME "CONDUCTOR"



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
~sendStartPlaying = { ~ips.do({ arg item; item.sendMsg("/start", "go")}) };

// function to send "dice" winner candidate to everyone
~sendDiceWinner = { arg diceWinner; ~ips.do({ arg item; item.sendMsg("/diceWinner", diceWinner)}) };

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
		candidate.postln;
		currentCount.postln;
		~tally[candidate] = currentCount + 1;
	},
	path: '/vote';
)


// find Winner Candidate ("dice result")
// and send it out right away
~findWinner = {
	var diceWinner = ~tally.maxIndex; // find winner
	~tally = Array.fill(~numberOfCandidates, 0); // clear array
	~sendDiceWinner.value(diceWinner); // sent it out
};



