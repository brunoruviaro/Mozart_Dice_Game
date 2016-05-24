// Mozart Conductor GUI


var win, winW, winH, textArray, buttonTempoClock, textBPM, buttonStartPlaying, countVotes, startReferendumButton, referendumMenu;

winW = 900;
winH = 600;

Window.closeAll;

win = Window.new("Conductor", Rect(left: 450, top: 160, width: winW, height: winH)).front;

win.alwaysOnTop = true;

win.background = Color.new255(102, 102, 102, 255);

// Change the gaps and margins to see how they work
win.view.decorator = FlowLayout(win.view.bounds, margin: 10@10, gap: 10@10 );

textArray = Array.fill(12, {StaticText.new(win, 64@200)});

textArray.do({arg item;
	item.string = "0";
	item.align = \center;
	item.font = Font("Monaco", 18, true);
	item.background = Color.rand;

});


// START METRONOME BUTTON
buttonTempoClock = Button.new(win, 286@100);
buttonTempoClock.states = [
	[ "(re)start metronome", Color.black, Color.yellow(0.9, 0.92) ],
	// [ "Metronome OFF", Color.white, Color.red(0.9, 0.5) ]
];
buttonTempoClock.font = Font.new(Font.default, 20, true);
buttonTempoClock.action = {arg bt;
	if(bt.value==1,
		{
			"started".postln;
			~sendTempoStart.value(140);
		},
		{
			"stopped".postln;
		}
	);
};

// START PLAYING!! BUTTON
buttonStartPlaying = Button.new(win, 286@100);
buttonStartPlaying.states = [
	[ "PLAY MOZART", Color.black, Color.green(0.9, 0.92) ],
	[ "STOP MOZART", Color.white, Color.red(0.9, 0.5) ]
];
buttonStartPlaying.font = Font.new(Font.default, 20, true);
buttonStartPlaying.action = {arg bt;
	if(bt.value==1,
		{
			"now playing".postln;
			~sendStartPlaying.value;
		},
		{
			"quit mozart".postln;
		}
	);
};

// BPM CHANGE TEXT FIELD
textBPM = EZText.new(
	parent: win,
	bounds: 64@100,
	label: "BPM",
	action: { arg ez;
		ez.value.postln;
		// ~sendTempoChange.value(ez.value);
	},
	initVal: 120,
	layout: \vert
);

textBPM.font = Font.new(Font.default, 20, true);
textBPM.setColors(stringColor: Color.white);

// COUNT VOTES
countVotes = Button.new(win, 210@100);
countVotes.states = [
	[ "COUNT VOTES", Color.black, Color.gray(0.9, 0.92) ],
];
countVotes.font = Font.new(Font.default, 20, true);
countVotes.action = {arg bt;
			"tallying votes...".postln;
			~findWinner.value;
};

// REFERENDUM
referendumMenu = EZPopUpMenu.new(
	parentView: win,
	bounds: 450@50,
	label: "REFERENDUM OPTIONS",
	items: ~referendumArray.collect({arg i; i.asSymbol}),
	globalAction: { arg menu; menu.value.postln; },
	labelWidth: 140,
	// layout: \vert
);

referendumMenu.font = Font.new(Font.default, 20, true);


// START REFERENDUM
startReferendumButton = Button.new(win, 416@50);
startReferendumButton.states = [
	[ "START REFERENDUM", Color.black, Color.green(0.7, 0.52) ],
	[ "END REFERENDUM", Color.white, Color.red(0.7, 0.52) ]
];
startReferendumButton.font = Font.new(Font.default, 20, true);
startReferendumButton.action = {arg bt;
	if(bt.value==1,
		{
			"starting referendum...".postln;
			// ~startReferendum.value(referendumMenu.value);
			referendumMenu.value.postln;
		},
		{
			"ENDING".postln
		}
	);
};


//
// t = StaticText.new(win, Rect(10, 10, winW - 10, 50))
// .string = "[0 , 1, 2, 3, 4, 5, 6, 7, 8, 9, 11]";
