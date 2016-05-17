s.waitForBoot({

SynthDef("pluck", {arg amp = 0.1, freq = 440, decay = 5;

var env, snd;
env = Env.linen(0, decay, 0).kr(doneAction: 2);
snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),
        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
		coef: LFNoise2.kr(1/4).range(0.1, 0.5);
		);
    Out.ar(0, [snd, snd]);
}).add;

}); // end of Wait For Boot


