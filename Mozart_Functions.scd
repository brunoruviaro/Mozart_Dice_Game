

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
// probably obsolete (default is 0).
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

// start continuous playback

OSCdef(
	key: \startPlay,
	func: {
		var nextMeasure;
		t.sched(0, {
			nextMeasure = ~getNextMeasureNumber.value(~part, ~winner, ~letterMeasure);
			~playMeasure.value(nextMeasure);
			// advance letter measure locally?
			if(~letterMeasureFlag==1, { ~advance.value });
			3; // repeat this function every 3 beats
		})
	},
	path: 'start'
);

// STOP playback (receive conductor command).

OSCdef(
	key: \stopPlay,
	func: {
		{ Window.closeAll }.defer;
		"Done!".postln;
		TempoClock.clear;
		s.freeAll;
		p.stop; q.stop; t.clear;
	},
	path: 'stop'
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
				// advance letter measure? (default is 0)
				if(~letterMeasureFlag==0, { ~advance.value });
			},
			{ "can't be zero, sorry" } // this means nobody voted yet
		);
	},
	path: '/diceWinner'
);

// referendum START
OSCdef(
	key: \startReferendum,
	func: { arg msg;
		msg.postln;
		{
			~referendumView.visible = true;
			~referendumText.string = ~referendumArray[ msg[1] ];
			~currentReferendum = msg[1]; // to be used when choosing winner action

		}.defer;
	},
	path: '/startReferendum'
);

// referendum END
OSCdef(
	key: \endReferendum,
	func: { arg msg;
		msg.postln;
		{ ~referendumView.visible = false; }.defer;
	},
	path: '/endReferendum'
);

// get referendum winner
OSCdef(
	key: \referendumWinner,
	func: { arg msg;
		msg.postln;
		if(msg[1]==1, // if winner was YES, take action
			{
				case
				{ ~currentReferendum == 0 } // faster
				{ t.tempo = t.tempo * 1.5 }

				{ ~currentReferendum == 1 } // slower
				{ t.tempo = t.tempo * 0.75 }

				{ ~currentReferendum == 2 } // transpose pretty
				{
					~transpRH = ~transpRH + 2;
					~transpLH = ~transpLH + 2;
				}

				{ ~currentReferendum == 3 } // transpose prettier
				{
					~transpRH = rrand(-2, 10);
					~transpLH = rrand(-4, 5);
				}

				{ ~currentReferendum == 4 } // make mozart great again
				{
					~transpRH = 0;
					~transpLH = 0;
					t.tempo = 120/60;
				}

				{ ~currentReferendum == 5 }
				{ "nothing here so far".postln }
			},
		);


	},
	path: '/referendumWinner'
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
		\ctranspose, Pfunc({ ~transpRH }),
		\dur, Pseq(~score[measure][0][1]) * 8, // m#, RH, durs
		\amp, 0.4,
		\legato, 0.9,
	).play(t, quant: 3);

	q = Pbind(
		\instrument, ~synthName,
		\midinote, Pseq(~score[measure][1][0]), // m#, LH, notes
		\ctranspose, Pfunc({ ~transpLH }),
		\dur, Pseq(~score[measure][1][1]) * 8, // m#, LH, durs
		\amp, 0.2,
		\legato, 0.5,
		\decay, 3
	).play(t, quant: 3);
};

// ========================================
// ADVANCE "TRANSPORT" (~letterMeasure and ~part)
// Move to next column in Number Table
// Move to Part II (and back to I) after 2 repeats
// ========================================

~advance = {

	// count repeats
	if(~letterMeasure==7,
		{
			~moveToNextPartFlag = ~moveToNextPartFlag + 1;
		}
	);

	// advance letter measure
	~letterMeasure = (~letterMeasure + 1) % 8;

	// move to next part if it's time to do so
	if(~moveToNextPartFlag==2,
		{
			case
			{~part==1} {~part = 2}
			{~part==2} {~part = 1};
			~moveToNextPartFlag = 0;
		}
	);


	// ("Part " ++ ~part).postln;
	// ("Column " ++ ~letterMeasure).postln;
	// " ".postln;

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

// =====================
// SEND REFERENDUM VOTE
// =====================
// Local player sends referendum vote to remote computer

~sendReferendumVote = { arg vote; ~destination.sendMsg("/referendumVote", vote) };




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
