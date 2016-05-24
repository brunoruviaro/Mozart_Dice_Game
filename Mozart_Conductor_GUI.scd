// Mozart Conductor GUI


var win, winW, winH, textArray, buttonTempoClock, textBPM, buttonStartPlaying, countVotes, endReferendumButton, referendumMenu, multiSlider, refYtext, refNtext;

winW = 900;
winH = 550;

Window.closeAll;

win = Window.new("Conductor", Rect(left: 450, top: 160, width: winW, height: winH)).front;

win.alwaysOnTop = true;

win.background = Color.new255(102, 102, 102, 255);

// Change the gaps and margins to see how they work
win.view.decorator = FlowLayout(win.view.bounds, margin: 10@10, gap: 10@10 );

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
	[ "(re)start metronome", Color.black, Color.yellow(0.9, 0.92) ],
	// [ "Metronome OFF", Color.white, Color.red(0.9, 0.5) ]
];
buttonTempoClock.font = Font.new(Font.default, 20, true);
buttonTempoClock.action = {arg bt;
	if(bt.value==0,
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
				endReferendumButton.visible = true;
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
	"counting referendum votes...".postln;
	~findReferendumWinner.value;
	endReferendumButton.visible = false;
	referendumMenu.value = 0;
};
endReferendumButton.visible = false;


//
// t = StaticText.new(win, Rect(10, 10, winW - 10, 50))
// .string = "[0 , 1, 2, 3, 4, 5, 6, 7, 8, 9, 11]";