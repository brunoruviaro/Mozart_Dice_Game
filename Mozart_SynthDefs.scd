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
			coef: LFNoise2.kr(1/4).range(0.2, 0.5);
		);
		Out.ar(0, [snd, snd]);
	}).add;


	SynthDef("pluckAM", {arg amp = 0.1, freq = 440, decay = 5, att = 0.01, ampAM = 0.05;

		var env, snd, carrier, modulator, envAM;
		env = Env.linen(0, decay, 0).kr(doneAction: 2);
		snd = Pluck.ar(
			in: WhiteNoise.ar(amp),
			trig: Impulse.kr(0),
			maxdelaytime: 0.1,
			delaytime: freq.reciprocal,
			decaytime: decay,
			coef: LFNoise2.kr(1/4).range(0.1, 0.5);
		);
		snd = LPF.ar(snd, LFNoise2.kr(1).range(1000, 5000));

		envAM = Env.perc(attackTime: att, releaseTime: decay/2, level: ampAM).kr;
		modulator = SinOsc.kr(freq: LFNoise2.kr(1/4).range(1.5, 2.1));
		carrier = SinOsc.ar(freq: [freq, freq*2.5, freq*4], mul: envAM * modulator) * [1, 0.01, 0.01];
		carrier = LPF.ar(carrier, LFNoise2.kr(3).range(1000, 5000));

		snd = Mix.ar(snd + carrier);

		Out.ar(0, [snd, snd]);
	}).add;

}); // end of Wait For Boot




