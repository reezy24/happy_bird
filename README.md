# Happy Bird :)

# Statement of Purpose and Scope
The purpose of this application is to replicate the game mechanics of the hit-game “Flappy Bird”, but in the terminal using Ruby. This application will aim to replicate the feel of Flappy Bird but will only draw graphics using regular ASCII characters. 

In Flappy Bird, the player must guide a bird through a series of pipes of varying heights. The player loses when the bird hits a pipe or they fail to keep the bird above the bottom boundary of the screen. It is an “infinite runner” type of game, in the sense that there is no end but rather the player is rewarded when the game ends. 

# Audience
From a game standpoint, the current way of technology is very immediate. We do not like to wait. Regardless, many have spare pockets of time – travelling on the train, waiting for a coffee, being the navigator in a pair programming exercise, etc. – that we’d rather fill with something more entertaining. These pockets of time is what these sorts of game aim to fill. 
From Coder Academy’s standpoint, this is a good way to collate learning from the foundational programming principles of the last couple weeks. This application provides the opportunity to touch on all parts of the course content thus far – from control flow, to inheritance, to version control. 

As mentioned earlier, the target audience is simply those who find themselves with short pockets of time – time not long enough to do something meaningful but long enough to feel bored and want to relieve this boredom. Students and commuters, for example. 

If we choose the example target audience of the Commuter, we know that they spend a lot of time waiting. A good example of usage of this application with the Commuter would be when they are waiting on the bus. Instead of simply waiting, they could pull out their Windows laptop, launch the terminal and enjoy a game or two of Happy Bird. 

# Features

## Feature 1 – Gameplay
The first feature is the simple gameplay mechanic of jumping. Jumping allows the player to avoid the pipes and stay alive. The variables would be the actual bird, the bird’s height, and the pipes. The game would loop 60 times a second to simulate 60 fps gameplay, which is the standard for most if not all modern titles across all platforms. We would use conditional control structures to check if the height of the bird is within the gap that the pipes create. If the bird does not clear the pipe, end the game.

## Feature 2 – Score Counter
This feature will keep track of how many pipes the player has cleared so far into the game. It will have a single variable which is the amount of pipes cleared. Each loop the game will check to see if the horizontal position of the bird is greater than the upcoming pipe. If the bird clears it completely, one point will be added to the score.

## Feature 3 – Leaderboard
This feature will store previous scores so the player can see a history of who has played and what they have scored. This will hold both player names and player scores in a hash.

# User Interaction and Experience

The user will learn how to interact with the application via the start screen of the game. The game will display “Press Space to start flapping!” which should give the player enough information on how the game works.

The user will use the space bar to jump, and jump according to where the pipes are on the screen. At the same time, their score will be visible in the bottom right corner. From the main menu or at the end of the game they will be able to access the leaderboard.

Should the game encounter an error, this will be communicated to the player with the cause where possible. They will have the option to restart the game. 

# Control Flow Diagram

![flowchart](https://github.com/reezy24/happy_bird/blob/master/images/d1.png)

# Implementation Plan

## Checklist

![checklist one](https://github.com/reezy24/happy_bird/blob/master/images/d2.png)
![checklist two](https://github.com/reezy24/happy_bird/blob/master/images/d3.png)

## Trello progression

Initial board:
![trello one](https://github.com/reezy24/happy_bird/blob/master/images/d4.png)

Sketches complete:
![trello two](https://github.com/reezy24/happy_bird/blob/master/images/d5.png)

Coding complete:
![trello three](https://github.com/reezy24/happy_bird/blob/master/images/d6.png)
