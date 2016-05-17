// ************************************
// "Ballot" GUI for voting
// Mozart Dice Game
// SCLOrk, Spring 2016
// ************************************

var win, buttonArray;

Window.closeAll;

win = Window.new("Ballot", Rect(450, 160, 250, 190)).front;

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


win.onClose = {
	Window.closeAll;
	"Done!".postln;
};

CmdPeriod.doOnce({Window.closeAll});

"Mozart Ballot".postln;
"".postln;