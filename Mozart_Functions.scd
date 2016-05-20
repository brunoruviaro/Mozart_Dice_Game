// ========
// OSCdefs
// ========
// (incoming messages from conductor)
// These OSCdefs allow remote conductor to:

// start local clock at any BPM
OSCdef(
	key: \tempoStart,
	func: { arg msg;
		var bpm = msg[1];
		t = TempoClock.new(bpm/60) ;
		("TempoClock started at " ++ bpm ++ " BPM").postln;
	},
	path: '/tempo/start'
);

// change BPM
OSCdef(
	key: \tempoChange,
	func: { arg msg;
		var bpm = msg[1];
		t.tempo = bpm/60;
		("TempoClock changed to " ++ bpm ++ " BPM").postln;
	},
	path: '/tempo/change'
);

// letterMeasure flag (who advances letter measures?)
OSCdef(
	key: \letterMeasureFlag,
	func: { arg msg;
		~letterMeasureFlag = msg[1];
		if(msg[1]==0,
			{
				("Letter Measures A, B, C... advanced by conductor").postln;
			},
			{
				("Letter Measures A, B, C... advanced locally").postln;
			}
		);

	},
	path: '/letterMeasureFlag'
);

~winner = 3; // just an initialization value
~letterMeasure = 0; // just an initialization value

// start continuous playback

OSCdef(
	key: \startPlay,
	func: {
		var nextMeasure;
		t.sched(0, {
			nextMeasure = ~getNextMeasureNumber.value(1, ~winner, ~letterMeasure);
			~playMeasure.value(nextMeasure);
			// advance letter measure locally?
			if(~letterMeasureFlag==1, { ~letterMeasure = (~letterMeasure + 1) % 8 });
			3; // repeat this function every 3 beats
		})
	},
	path: 'start'
);


// incoming winner candidate ("dice") and optional letterMeasure
OSCdef(
	key: \incomingDice,
	func: { arg msg;
		msg.postln;
		if(msg[1]>0,
			{
				~winner = msg[1];
				("Incoming dice: " ++ ~winner).postln;
				// advance letter measure?
				if(~letterMeasureFlag==0, { ~letterMeasure = (~letterMeasure + 1) % 8 });
			},
			{ "can't be zero, sorry" } // this means nobody voted yet
		);
	},
	path: '/diceWinner'
);



// ~rightHere = NetAddr("127.0.0.1", 57120);
// ~rightHere.sendMsg('/tempo/start', 154)
// ~rightHere.sendMsg('/tempo/change', 294)
// Pbind(\degree, Pwhite(0, 10)).play(t);
// ~rightHere.sendMsg('/measure/winner', 94)

// =====================
// PLAY WINNING MEASURE
// =====================

~playMeasure = {arg measure = 1;

	p = Pbind(
		\instrument, ~synthName,
		\midinote, Pseq(~score[measure][0][0]), // m#, RH, notes
		\dur, Pseq(~score[measure][0][1]) * 8, // m#, RH, durs
		\amp, 0.2,
		\legato, 0.5,
	).play(t, quant: 3);

	q = Pbind(
		\instrument, ~synthName,
		\midinote, Pseq(~score[measure][1][0]), // m#, LH, notes
		\dur, Pseq(~score[measure][1][1]) * 8, // m#, LH, durs
		\amp, 0.2,
		\legato, 0.5
	).play(t, quant: 3);
};

// ========================================
// GET NEXT MEASURE NUMBER
// Finds correct measure number to play
// ========================================

~getNextMeasureNumber = { arg part = 1, dice = 3, letterMeasure = 0;
	if(part==1,
		{ ~firstPart[dice][letterMeasure] },
		{ ~secondPart[dice][letterMeasure] }
	);
};

// =====================
// SEND VOTE TO TALLY
// =====================
// Local player sends vote to remote computer

~sendVote = { arg vote; ~destination.sendMsg("/vote", vote) };




// leftovers

// ~playMeasure.value(92);

// test only
// SystemClock.sched(0, { v = rrand(1, 20); v.postln; ~playMeasure.value(v); 1 });


// more testing
/*(
var letterMeasure = 0;
t.sched(0, {
var dice = rrand(2, 12); // from voting
var dice = ~winningMeasure;
var measure = ~firstPart[dice][letterMeasure];
~playMeasure.value(measure);
letterMeasure = (letterMeasure + 1) % 8;
3;

})
)*/
