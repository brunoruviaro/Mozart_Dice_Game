// Mozart Conductor GUI


var parentWin, win, winW, winH, textArray, buttonTempoClock, textBPM, buttonStartPlaying, countVotes, shortcutCtext, endReferendumButton, referendumMenu, multiSlider, refYtext, refNtext, protestSign, superdelegateWarning;

winW = 900;
winH = 550;

Window.closeAll;

parentWin = Window.new("Conductor", Window.screenBounds);
parentWin.alwaysOnTop = true;
parentWin.front;

win = CompositeView.new(
	parent: parentWin,
	bounds: Rect(
		left: ((Window.screenBounds.width - winW) / 2).round(1);,
		top: 60,
		width: winW,
		height: winH)
);

// parentWin.background = Color.new255(255, 255, 255, 255);
win.background = Color.new255(102, 102, 102, 255);

shortcutCtext = StaticText.new(win, Rect(winW - 145, winH - 225, 100, 50));
shortcutCtext.string = "shortcut C";
shortcutCtext.font = Font.new(Font.default, 11);

// Change the gaps and margins to see how they work
win.decorator = FlowLayout(win.bounds, margin: 10@10, gap: 10@10 );

// Multislider
multiSlider = MultiSliderView(win, 880@200);
multiSlider.value = Array.fill(12, {0.0});
multiSlider.isFilled = true;
multiSlider.indexThumbSize = 64.0;
multiSlider.elasticMode = 1;
multiSlider.editable = false;
multiSlider.value = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

textArray = Array.fill(12, {StaticText.new(win, 64@50)});

textArray.do({arg item;
	item.string = "0";
	item.align = \center;
	item.font = Font("Monaco", 18, true);
	item.background = Color.rand;

});


// START METRONOME BUTTON
buttonTempoClock = Button.new(win, 286@100);
buttonTempoClock.states = [
	[ "START METRONOME", Color.black, Color.yellow(0.9, 0.92) ],
	// [ "Metronome OFF", Color.white, Color.red(0.9, 0.5) ]
];
buttonTempoClock.font = Font.new(Font.default, 20, true);
buttonTempoClock.action = {arg bt;
	if(bt.value==0,
		{
			"started".postln;
			~sendTempoStart.value(~bpm);
			textBPM.value = ~bpm;
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
			// visualize incoming votes
			f = {
				inf.do{
					~tally.postln;
					~referendumTally.postln;
					0.9.wait;

					{
						// update number views (main voting)
						textArray.do({arg item, count;
							item.string = ~tally[count+1]
						});
						// update multislider (main voting)
						if(~tally.maxItem<200,
							{
								multiSlider.value = ~tally[1..12] / 200;
							},
							{
								multiSlider.value = ~tally[1..12] / 400;
							}
						);
						// update referendum N/Y voting
						refNtext.string = ~referendumTally[0];
						refYtext.string = ~referendumTally[1];
					}.defer;
				}
			}.fork;
		},
		{
			"quit mozart".postln;
			f.stop;
			~sendStopPlaying.value;
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
		~sendTempoChange.value(ez.value);
		~bpm = ez.value;
		countVotes.focus(true);
	},
	initVal: ~bpm.asInteger,
	layout: \vert
);

textBPM.font = Font.new(Font.default, 20, true);
textBPM.setColors(stringColor: Color.white);

// COUNT VOTES
countVotes = Button.new(win, 210@100);
countVotes.states = [
	[ "COUNT VOTES", Color.black, Color.gray(0.9, 0.6) ],
];
countVotes.font = Font.new(Font.default, 20, true);
countVotes.action = {arg bt;
	"tallying votes...".postln;
	~findWinner.value;
	{
		{ bt.states = [[ "COUNT VOTES", Color.white, Color.black ]] }.defer;
		0.1.wait;
		{ bt.states = [[ "COUNT VOTES", Color.black, Color.gray(0.9, 0.6) ]] }.defer;
	}.fork;
};

win.keyDownAction = {arg view, char, mod, unicode;
	if((unicode==99) || (unicode==67),
		{ countVotes.valueAction = 0; },
		{ "no action for keys other than C" }
	);
};


// REFERENDUM
referendumMenu = EZPopUpMenu.new(
	parentView: win,
	bounds: 430@50,
	label: "REFERENDUM",
	items: (["pick item to start..."] ++ ~referendumArray).collect({arg i; i.asSymbol}),
	globalAction: { arg menu;
		if(menu.value>0,
			{
				"starting referendum...".postln;
				// minus one below is needed because
				// I added the "pick item to start..."
				// as first item just for pop up menu
				~startReferendum.value(menu.value - 1);
				~currentReferendum = menu.value - 1;
				endReferendumButton.visible = true;
				endReferendumButton.focus(true);
			};
		);
	},
	labelWidth: 140,
	// layout: \vert
);

referendumMenu.font = Font.new(Font.default, 20, true);


// N and Y display
refNtext = StaticText.new(win, 30@50);
refNtext.string = "N";
refNtext.align = \center;
refNtext.font = Font.new(Font.default, 18, true);
refNtext.background = Color.red(0.3, 0.3);

refYtext = StaticText.new(win, 30@50);
refYtext.string = "Y";
refYtext.align = \center;
refYtext.font = Font.new(Font.default, 18, true);
refYtext.background = Color.green(0.6, 0.5);



// END REFERENDUM
endReferendumButton = Button.new(win, 316@50);
endReferendumButton.states = [
	[ "END REFERENDUM", Color.white, Color.red(0.7, 0.52) ]
];
endReferendumButton.font = Font.new(Font.default, 20, true);
endReferendumButton.action = {arg bt;
	var refWinner;
	"counting referendum votes...".postln;
	refWinner = ~findReferendumWinner.value;
	endReferendumButton.visible = false;
	referendumMenu.value = 0;
	if(refWinner==1,
		{
			case
			{~currentReferendum==0}{~bpm = (~bpm * 1.25).asInteger; textBPM.value = ~bpm}
			{~currentReferendum==1}{~bpm = (~bpm * 0.8).asInteger; textBPM.value = ~bpm}
			{~currentReferendum==4}{~bpm = 170; textBPM.value = ~bpm; }

		};
	);

};
endReferendumButton.visible = false;

protestSign = StaticText.new(win, (winW/2-15)@90);
protestSign.string = "#1 = Protest Vote!";
protestSign.align = \center;
protestSign.font = Font.new(Font.default, 28, true);
protestSign.background = Color.gray(0.9, 0.91);
protestSign.stringColor = Color.red;
protestSign.visible = false;

superdelegateWarning = StaticText.new(win, (winW/2-15)@90);
superdelegateWarning.string = "[WARNING: SOMEONE IS IN SUPERDELEGATE MODE]";
superdelegateWarning.align = \center;
superdelegateWarning.font = Font.new(Font.default, 21, true);
superdelegateWarning.stringColor = Color.black;
superdelegateWarning.background = Color.gray(0.9, 0.91);
superdelegateWarning.visible = false;

~sda = nil;
~superdelegateAlert = {arg onOff = 0;
	"running SD function".postln;
	case
	// case1: turn flashing on
	{ (onOff==1) && (~sda==nil) }
	{
		// "onOff is 1, sda is nil".postln;
		~sda = {
			{
				{ superdelegateWarning.visible = true }.defer;
				0.35.wait;
				{ superdelegateWarning.visible = false }.defer;
				0.35.wait;
				// "end of loop".postln
			}.loop;
		}.fork;
	}
	// case2: turn flashing off
	{ (onOff==0) && (~sda!=nil) }
	{
		"onOff is 0, sda was not nil, but now should be".postln;
		~sda.stop;
		~sda = nil;
		{ superdelegateWarning.visible = false }.defer;
	};
};

~psa = nil;
~protestSignAlert = {arg onOff = 0;
	"running function".postln;
	case
	// case1: turn flashing on
	{ (onOff==1) && (~psa==nil) }
	{
		~psa = {
			{
				{ protestSign.visible = true }.defer;
				0.35.wait;
				{ protestSign.visible = false }.defer;
				0.15.wait;
				// "end of loop".postln
			}.loop;
		}.fork;
	}
	// case2: turn flashing off
	{ (onOff==0) && (~psa!=nil) }
	{
		~psa.stop;
		~psa = nil;
		protestSign.visible = false
	};
};

parentWin.onClose = {
	~sda.stop; ~sda = nil;
	~psa.stop; ~psa = nil;

};

//
// t = StaticText.new(win, Rect(10, 10, winW - 10, 50))
// .string = "[0 , 1, 2, 3, 4, 5, 6, 7, 8, 9, 11]";
