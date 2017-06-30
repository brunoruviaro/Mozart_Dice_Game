# Mozart and the Elections
*For Laptop Orchestra, based on Mozart's Musical Dice Game*
by Bruno Ruviaro

Premiered by SCLOrk (the Santa Clara Laptop Orchestra) on June 2, 2016 at Santa Clara University.

### Program notes:

> This is a tragicomic piece on the state of American democracy through the lenses of Mozart’s Musical Dice Game. It was composed during the presidential primaries season of 2016. Each player obsessively votes as fast as they can to elect the next measure from a pool of candidates. A supposedly fair conductor counts the votes when he or she wishes. Players can use a Super Delegate button to make their votes be worth 10 times more than everyone else’s. Every now and then the conductor throws referendum questions to the players to decide the development of the piece. Referendum questions used in this performance were: “Slower?” — “Faster?” — “Transpose Pretty?” — “Transpose Prettier?” — “Make Mozart Great Again?” — “Lesser Evil?”. The audience follows everything on screen by watching the conductors “dashboard”. The piece ends when the system crashes.

## About Mozart's Dice Game

"To Compose Without The Least Knowledge of Music so Much German Walzer or Schleifer as one pleases, by throwing a certain number with two dice."

https://en.wikipedia.org/wiki/Musikalisches_W%C3%BCrfelspiel

http://imslp.org/wiki/Musikalisches_W%C3%BCrfelspiel,_K.516f_%28Mozart,_Wolfgang_Amadeus%29

## How to play

## Getting the files
1. Clone or download this github directory. If manually downloaded, unzip the file.
2. You will need a minimum of two laptops to test the system, both connected to the same local network (Ethernet cable preferred; wi-fi OK, but you may experience time sync issues). All laptops should have the same set of scd files (i.e., the complete github folder).
3. One laptop will be the CONDUCTOR, while all other laptops will be PLAYERS.
4. CONDUCTOR laptop will open and runs the Mozart_CONDUCTOR.scd file. All other laptops run Mozart_PLAYER.scd file.
5. Before running the piece, there is some simple configuration of IP addresses to be done -- see below.
6. These instructions assume basic familiarity with SuperCollider (how to run things, etc). If you are not familiar with SuperCollider, look up "Gentle Introduction to SuperCollider"... ;-)

## IP addresses

1. **On each PLAYER laptop**, in the file Mozart_PLAYER.scd, the line with the `~destination` variable must be updated to reflect the IP address of the CONDUCTOR laptop. Usually you can find the local IP address of your computer by going to Network Preferences in your system. It should look more or less like this (number between double quotes is what you need to change; the number 57120 should not be changed):
```
~destination = NetAddr("192.168.42.69", 57120); // conductor IP address
```
2. **On the CONDUCTOR laptop only**, you need to open the file Mozart_IP_Addresses.scd and enter a valid IP address for each PLAYER laptop you plan to use. You will see in that file a bunch of lines I have used in different performances. You can delete or comment out all of those. Your file should have as many NetAddr lines as PLAYER laptops you have. For example, if you are playing in a small group of 6 laptops (1 conductor + 5 players), your Mozart_IP_Addresses.scd file on your CONDUCTOR laptop might look like this:
```
// ORCHESTRA PLAYERS IP ADDRESSES
~ips = [
	NetAddr("192.168.1.101", 57120),  
  	NetAddr("192.168.1.102", 57120),
	NetAddr("192.168.1.103", 57120),
	NetAddr("192.168.1.104", 57120), 
	NetAddr("192.168.1.105", 57120), 
];
```
Note: The IP address of each line should be the valid IP addresses of PLAYER laptops currently connected to the same local network. *If one of the PLAYER laptops included in this list is shut down, disconnected, or absent in a given rehearsal, you should comment out its line from the list. Otherwise SuperCollider might throw an error when you run the CONDUCTOR file.*

## Run the code
* CONDUCTOR laptop: in the Mozart_CONDUCTOR.scd file, simply evaluate, in order, the four lines that load everything (no other files need to be open). The CONDUCTOR Graphical User Interface will show up.
```
// Load IPs
"Mozart_IP_Addresses.scd".loadRelative;

// Load some variables
"Mozart_Init_Variables.scd".loadRelative;

// Load some functions
"Mozart_Conductor_Functions.scd".loadRelative;

// Load GUI
"Mozart_Conductor_GUI.scd".loadRelative;
```
* PLAYER laptops: in the Mozart_PLAYER.scd file, simply evaluate the entire code block at once. The PLAYER Graphical User Interface (GUI) will show up.

## Graphical Interfaces

This is the PLAYER interface:

![player](https://user-images.githubusercontent.com/4010596/27749992-cc0d6270-5d8a-11e7-8390-51f4e1bc390c.png)

And this is the CONDUCTOR interface:

![conductor](https://user-images.githubusercontent.com/4010596/27750032-e85242d4-5d8a-11e7-96d1-80486faaa7ee.png)

## Playing instructions
* CONDUCTOR laptop should be projecting GUI on the wall so everyone can see it, including audience.

* CONDUCTOR clicks on `Start Metronome` button. PLAYER laptops should see a message in their Post Window acknowledging the metronome start.

* CONDUCTOR clicks on `Play Mozart` button. All PLAYER laptops automatically start making sounds; no action yet needed from human players.

* PLAYERS start to vote on candidates as many times as they want (each number represents a possible next measure). Everyone can monitor the tallying of votes on the CONDUCTOR screen projected on the wall.
    * The group should soon find out that "overvoting" becomes part of the piece as a competitive activity: I've seen people trying to click as fast as they can on their chosen candidate to try and make it win the next round.
* CONDUCTOR decides when and how often to count votes.
    * Counting votes means one of candidates will win, making the music move on to one of the 12 possible next measures. The voting returns to a clean slate and voting resumes from zero.
    * CONDUCTOR can experiment with counting votes every 2 or 3 beats to make the music move forward faster, or delaying the vote count to allow a looping measure to continue for a while (also allowing for votes to pile up on the screen, increasing 'tension' among voters, etc).
    * It's easier to use keyboard shortcut `C` instead of clicking the button `Count Votes` (both methods accomplish the same thing).

* PLAYERS may at any time click their `SuperDelegate Mode` button. This will make their votes be worth a lot more than ordinary votes. This special mode, however, only works for a few seconds, then it expires.

* CONDUCTOR may at any time throw a `Referendum` question to the group. The question shows up on all PLAYERs interfaces, and they have to vote Yes or No. CONDUCTOR can choose to end the referendum at anytime. The result of this referendum changes some aspect of the music being played.

* Over a few rehearsals, the CONDUCTOR should be able to understand the typical game dynamics arising from the options available in this piece. Rather than simply randomly tallying votes and throwing referendum questions, the conductor should be at all times trying to sense what's going on in the music and in the ensemble, and consciously play with the possibilities and expectations. A musical ear and a sense of humor are indispensable to conduct this piece.

* The piece may be as short or as long as the ensemble wants. Typically I've found 3 to 5 minutes to work best for this piece. Conductor and players should agree that, at some point, the group will make the piece go faster and faster until SuperCollider crashes on as many machines as possible (it will make a relatively loud single pitch when it crashes; this is not designed in my code, it is actually the sound of overloading the SC server). That is the end of the piece. The loud noise should sound for 1-2 seconds and then all players should stop the sound together (either bringing their volumes down on audio interfaces, or quitting SuperCollider).





