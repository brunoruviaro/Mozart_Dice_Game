// function to play a measure starting on next downbeat

t = TempoClock.new(20/60);

(
~playMeasure = {arg measure = 1;

Pbind(
	\midinote, Pseq(~score[measure][0][0]), // m#, RH, notes
	\dur, Pseq(~score[measure][0][1]), // m#, RH, durs
	\amp, 0.2,
	\legato, 0.5,
).play(t, quant: 3/8);

Pbind(
	\midinote, Pseq(~score[measure][1][0]), // m#, LH, notes
	\dur, Pseq(~score[measure][1][1]), // m#, LH, durs
	\amp, 0.2,
	\legato, 0.5
).play(t, quant: 3/8);
}
)

// test only
SystemClock.sched(0, { v = rrand(1, 20); v.postln; ~playMeasure.value(v); 1 });


// more testing
(
var letterMeasure = 0;
t.sched(0, {
	var dice = rrand(2, 12); // from voting
	var measure = ~firstPart[dice][letterMeasure];
	~playMeasure.value(measure);
	letterMeasure = (letterMeasure + 1) % 8;
	3/8;

})
)


