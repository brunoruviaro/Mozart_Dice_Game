// MOZART DICE GAME "CONDUCTOR"


~ips = [
    NetAddr("192.168.42.69", 57120),
    NetAddr("10.0.1.2", 57120),
    NetAddr("10.0.1.3", 57120),
    NetAddr("10.0.1.4", 57120),
    NetAddr("10.0.1.5", 57120),
    NetAddr("10.0.1.6", 57120),
    NetAddr("10.0.1.7", 57120),
    NetAddr("10.0.1.8", 57120),
    NetAddr("10.0.1.9", 57120),
    NetAddr("10.0.1.10", 57120),
    NetAddr("10.0.1.11", 57120),
    NetAddr("10.0.1.12", 57120),
    NetAddr("10.0.1.13", 57120),
    NetAddr("10.0.1.14", 57120),
    NetAddr("10.0.1.15", 57120),
    NetAddr("10.0.1.16", 57120),
];

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



