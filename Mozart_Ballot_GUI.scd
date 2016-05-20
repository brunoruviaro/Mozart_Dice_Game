// ************************************
// "Ballot" GUI for voting
// Mozart Dice Game
// SCLOrk, Spring 2016
// ************************************

var win, buttonArray, superDelegates, supDel = 0;

Window.closeAll;

win = Window.new("Ballot", Rect(left: 450, top: 160, width: 250, height: 290)).front;

win.alwaysOnTop = true;

win.background = Color.new255(102, 102, 102, 255);

// Change the gaps and margins to see how they work
win.view.decorator = FlowLayout(win.view.bounds, margin: 10@10, gap: 10@10 );

buttonArray = Array.fill(12, {Button(win.view, 50@50)});

buttonArray.do({arg item, count;
	item.states = [[ count + 1, Color.black, Color.rand ]]});

buttonArray.do({arg item, count;
	item.action = {arg bt;
		var myVote = count + 1;
		("I vote for " ++ (myVote)).postln;
		~sendVote.value(myVote);
}});

//
superDelegates = Button.new(win.view, 230@50);
superDelegates.states = [[ "SUPERDELEGATE MODE", Color.black, Color.yellow ]];
superDelegates.action = {arg bt;
	"printme".postln;
	if(supDel==0,
		{
			{
				supDel = 1;
				{
					{ superDelegates.states = [[ "SUPERDELEGATE MODE ON", Color.white, Color.red ]] }.defer;
					0.1.wait;
					{ superDelegates.states = [[ "CHEATER!", Color.black, Color.yellow ]] }.defer;
					0.1.wait;
				}.loop;
			}.fork
		},
		{
			"you ran out of superdelegates".postln;
		}
	);
};


win.onClose = {
	Window.closeAll;
	"Done!".postln;
	TempoClock.clear;
	s.freeAll;
};

CmdPeriod.doOnce({Window.closeAll});

"Mozart Ballot".postln;
"".postln;