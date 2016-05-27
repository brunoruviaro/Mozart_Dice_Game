// Mozart PLAYER


(
// ~synthName = "default";
// ~synthName = "pluck";
~synthName = "pluckAM";
"Mozart_IP_Addresses.scd".loadRelative;
"Mozart_Init_Variables.scd".loadRelative;
"Mozart_Functions.scd".loadRelative;
"Mozart_Musical_Dice_Full_Score.scd".loadRelative;
"Mozart_Number_Tables.scd".loadRelative;
"Mozart_Ballot_GUI.scd".loadRelative;
"Mozart_SynthDefs.scd".loadRelative;
)






// in case of emergency
p.stop; q.stop; t.clear;

// NetAddr.langPort