// MOZART DICE GAME "CONDUCTOR"




~sendTempoStart = { arg bpm;
	~ips.do({ arg item;
		item.sendMsg("/tempo/start", bpm)
	});
};

~sendTempoChange = { arg bpm;
	~ips.do({ arg item;
		item.sendMsg("/tempo/change", bpm)
	});
};

~sendStartPlaying = { ~ips.do({ arg item; item.sendMsg("/start", "go")}) };

~sendWinner = { arg winner; ~ips.do({ arg item; item.sendMsg("/measure/winner", winner)}) };



~numberOfPlayers = ~ips.size;

("Number of IPs listed: " ++ ~numberOfPlayers).postln;



