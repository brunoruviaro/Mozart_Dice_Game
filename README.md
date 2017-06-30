# Mozart and the Elections
For Laptop Orchestra, based on Mozart's Musical Dice Game

Premiered by SCLOrk (the Santa Clara Laptop Orchestra) on June 2, 2016 at Santa Clara University.

Program notes:
This is a tragicomic piece on the state of American democracy through the lenses of Mozart’s Musical Dice Game. It was composed during the presidential primaries season of 2016. Each player obsessively votes as fast as they can to elect the next measure from a pool of candidates. A supposedly fair conductor counts the votes when he or she wishes. Players can use a Super Delegate button to make their votes be worth 10 times more than everyone else’s. Every now and then the conductor throws referendum questions to the players to decide the development of the piece. Referendum questions used in this performance were: “Slower?” — “Faster?” — “Transpose Pretty?” — “Transpose Prettier?” — “Make Mozart Great Again?” — “Lesser Evil?”

The audience follows everything on screen by watching the conductors “dashboard”. The piece ends when the system crashes.

# Mozart's Dice Game

"To Compose Without The Least Knowledge of Music so Much German Walzer or Schleifer as one pleases, by throwing a certain number with two dice."

https://en.wikipedia.org/wiki/Musikalisches_W%C3%BCrfelspiel

http://imslp.org/wiki/Musikalisches_W%C3%BCrfelspiel,_K.516f_%28Mozart,_Wolfgang_Amadeus%29

# How to play

## Getting the files
1. Clone or download this github directory. If manually downloaded, unzip the file.
2. You will need a minimum of two laptops to test the system, both connected to the same local network (Ethernet cable preferred; wi-fi OK, but you may experience time sync issues). All laptops should have the same set of scd files (i.e., the complete github folder).
3. One laptop will be the CONDUCTOR, while all other laptops will be PLAYERS.
4. CONDUCTOR laptop will open and runs the Mozart_CONDUCTOR.scd file. All other laptops run Mozart_PLAYER.scd file.
5. Before running the piece, there is some simple configuration of IP addresses to be done -- see below.

## IP addresses

1. On each PLAYER laptop, the line with the `~destination` variable must be updated to reflect the IP address of the CONDUCTOR laptop. Usually you can find the local IP address of your computer by going to Network Preferences in your system. It should look more or less like this (number between double quotes is what you need to change):
```
~destination = NetAddr("192.168.42.69", 57120); // conductor IP address
```
2. **On the CONDUCTOR laptop only**, you need to open the file Mozart_IP_Addresses.scd and enter a valid IP address for each PLAYER laptop you plan to use. You will see in that file a bunch of lines I have used in different performances. You can delete or comment out all of those. *Your* file should have as many NetAddr lines as PLAYER laptops you have. For example, if you are playing in a small group of 6 laptops (1 conductor + 5 players), your Mozart_IP_Addresses.scd file on your CONDUCTOR laptop might look like this:
```
// ORCHESTRA PLAYERS IP ADDRESSES
~ips = [
	NetAddr("192.168.1.101", 57120),  
  NetAddr("192.168.1.102", 57120),
	NetAddr("192.168.1.103", 57120),  
];
```
Note: The IP address of each line should be the valid IP addresses of PLAYER laptops currently connected to the same local network. *If one of the PLAYER laptops included in this list is shut down, disconnected, or absent in a given rehearsal, you should comment out its line from the list. Otherwise SuperCollider might throw an error when you run the CONDUCTOR file.*


