// Mozart Conductor GUI


var win, winW, winH, textArray, buttonTempoClock;

winW = 900;
winH = 600;

Window.closeAll;

win = Window.new("Conductor", Rect(left: 450, top: 160, width: winW, height: winH)).front;

win.alwaysOnTop = true;

win.background = Color.new255(102, 102, 102, 255);

// Change the gaps and margins to see how they work
win.view.decorator = FlowLayout(win.view.bounds, margin: 10@10, gap: 10@10 );

textArray = Array.fill(12, {StaticText.new(win, 64@60)});

textArray.do({arg item;
	item.string = "0";
	item.align = \center;
	item.font = Font("Monaco", 14);
	item.background = Color.rand;

});


buttonTempoClock = Button.new(win, 286@100);
buttonTempoClock.states = [
	[ "Start Metronome", Color.black, Color.yellow(0.9, 0.52) ],
	[ "Stop Metronome", Color.black, Color.red(0.9, 0.2) ]
];
buttonTempoClock.font = Font.new(Font.default, 20, true);





//
// t = StaticText.new(win, Rect(10, 10, winW - 10, 50))
// .string = "[0 , 1, 2, 3, 4, 5, 6, 7, 8, 9, 11]";
