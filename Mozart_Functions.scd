
// put this somewhere player settings
~destination = NetAddr("192.168.42.66", 57210);


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


// start continuous playback
OSCdef(
	key: \startPlay,
	func: {
		var letterMeasure = 0;
		t.sched(0, {
			// var dice = rrand(2, 12);
			var dice = ~winner; // from election results
			var measure = ~firstPart[dice][letterMeasure];
			~playMeasure.value(measure);
			letterMeasure = (letterMeasure + 1) % 8;
			3; // repeat this function every 3 beats
			// we are hoping a new ~winner measure will be defined by then. If not, it will just repeat the older one...
		})
	},
	path: 'start'
);


// winner measure
OSCdef(
	key: \winnerMeasure,
	func: { arg msg;
		~winner = msg[1];
		("Incoming winning measure: " ++ ~winner).postln;
	},
	path: '/measure/winner'
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
	\midinote, Pseq(~score[measure][0][0]), // m#, RH, notes
	\dur, Pseq(~score[measure][0][1]) * 8, // m#, RH, durs
	\amp, 0.2,
	\legato, 0.5,
).play(t, quant: 3);

q = Pbind(
	\midinote, Pseq(~score[measure][1][0]), // m#, LH, notes
	\dur, Pseq(~score[measure][1][1]) * 8, // m#, LH, durs
	\amp, 0.2,
	\legato, 0.5
).play(t, quant: 3);
};


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


// =====================
// SEND VOTE TO TALLY
// =====================
// Local player sends vote to remote computer

~sendVote = { arg vote; ~destination.sendMsg("/vote", vote) };

