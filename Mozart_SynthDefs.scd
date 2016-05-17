

SynthDef("pluck", {arg amp = 0.1, freq = 440, decay = 5;

var env, snd;
env = Env.linen(0, decay, 0).kr(doneAction: 2);
snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),
        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
		coef: Lag.kr(In.kr(~wiiXbus), 1).clip(0.1, 0.9);
    Out.ar(0, [snd, snd]);
}).add;

