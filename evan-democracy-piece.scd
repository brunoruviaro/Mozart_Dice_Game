// B =

~destination = NetAddr("172.20.75.200", 57210);


~destination.sendMsg("/stuff", 12, 16);


~numberOfCandidates = 16; // because of QuNeo buttons
~numberOfVoters = 13; // number of players

~voted = Array.newClear(~numberOfVoters);
~tally = Array.fill(~numberOfCandidates, 0);


~tally[0] = ~tally[0] + 1

(
OSCdef(\test, {arg ...args;
	var voterID, candidate;
	voterID = args[0][1]; // double check
	candidate = args[0][0]; // double check

	if(~voted[voteID]==0,
		{
			~voted[voterID] = 1;
			~tally[candidate] = ~tally[candidate] + 1;
		},
		{
			"you are trying to voice twice, huh?".postln;
		}
	);

}, path: '/stuff');
)


// From Evan's laptop
//

(
~destinations = [
	"192.19.121.121",
	"192.19.121.121",
	"192.19.121.121",
	// etc
];
)


// Start TempoClock on everyone's laptop
(
~destinations.do({arg item;
	item.sendMsg(/* start TempoClock */);
	t = TempoClock.new; // your local tempo clock
});
)

// corresponding code on everyone's laptop:
(
OSCdef(\tempoStart, {arg ...args;

	t = TempoClock.new;

	},
	path: '/tempo'
)
)

// TEMPO CLOCK controls tallying and sending results out



