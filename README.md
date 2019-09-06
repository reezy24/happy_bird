# happy_bird

Statement of Purpose and Scope (300 – 500) [316]
Develop a statement of purpose and scope for your application. It must include:
The purpose of this application is to replicate the game mechanics of the hit-game “Flappy Bird”. This application will aim to replicate the feel of Flappy bird but will only draw graphics using regular ASCII characters. 

- describe at a high level what the application will do
In Flappy Bird, the player must guide a bird through a series of pipes of varying heights. The player loses when the bird hits a pipe or they fail to keep the bird above the bottom boundary of the screen. It is an “infinite runner” type of game, in the sense that there is no end but rather the player is rewarded when the game ends. 

- identify the problem it will solve and explain why you are developing it
From a game standpoint, the current way of technology is very immediate. We do not like to wait. Regardless, many have spare pockets of time – travelling on the train, waiting for a coffee, being the navigator in a pair programming exercise, etc. – that we’d rather fill with something more entertaining. These pockets of time is what these sorts of game aim to fill. 
From Coder Academy’s standpoint, this is a good way to collate learning from the foundational programming principles of the last couple weeks. This application provides the opportunity to touch on all parts of the course content thus far – from control flow, to inheritance, to version control. 

- identify the target audience 
As mentioned earlier, the target audience is simply those who find themselves with short pockets of time – time not long enough to do something meaningful but long enough to feel bored and want to relieve this boredom. Students and commuters, for example. 

- explain how a member of the target audience will use it
If we choose the example target audience of the Commuter, we know that they spend a lot of time waiting. A good example of usage of this application with the Commuter would be when they are waiting on the bus. Instead of simply waiting, they could pull out their Windows laptop, launch the terminal and enjoy a game or two of Happy Bird. 

Features (300, 100 per feature)
Develop a list of features that will be included in the application. It must include:
- at least THREE features
- describe each feature


Ensure that your features include the following language elements and concepts:
- use of variables and the concept of variable scope (as in simply identifying what will be stored as variables? How to express scope?)
- loops and conditional control structures
- error handling

Feature 1 – flap (i.e. actual gameplay) [90]
The first feature is the simple gameplay mechanic of jumping. Jumping allows the player to avoid the pipes and stay alive. The variables would be the actual bird, the bird’s height, and the pipes. The game would loop 60 times a second to simulate 60 fps gameplay, which is the standard for most if not all modern titles across all platforms. We would use conditional control structures to check if the height of the bird is within the gap that the pipes create. If the bird does not clear the pipe, end the game. 
Feature 2 – score counter [60]
This feature will keep track of how many pipes the player has cleared so far into the game. It will have a single variable which is the amount of pipes cleared. Each loop the game will check to see if the horizontal position of the bird matches or is greater to the next pipe. If the bird clears it, one point will be added to the score. 
Feature 3 – leaderboard [30]
This feature will store previous scores so the player can see a history of who has played and what they have scored. This will hold both player names and player scores as variables.

User Interaction and Experience (no word limit)
Develop an outline of the user interaction and experience for the application.
Your outline must include:
- how the user will find out how to interact with / use each feature
The user will learn how to interact with the application via the start screen of the game. The game will display “Press Space to start flapping!” which should give the player enough information on how the game works. This will be confirmed in testing, though. 

- how the user will interact with / use each feature
The user will use the space bar to play the game, and press space according the state of the game on the screen. At the same time, their score will be visible in the bottom left corner. From the main menu they will be able to access the leaderboard.

- how errors will be handled by the application and displayed to the user
As it is a game, all errors will be ironed out prior to release. Should there be any errors, I don’t really know what to tell you, to be honest. 

Control Flow Diagram
Develop a diagram which describes the control flow of your application. Your diagram must:
- show the workflow/logic and/or integration of the features in your application for each feature.
- utilise a recognised format or set of conventions for a control flow diagram, such as UML.  
 

Implementation Plan
Develop an implementation plan which:
- outlines how each feature will be implemented and a checklist of tasks for each feature
- prioritise the implementation of different features, or checklist items within a feature
- provide a deadline, duration or other time indicator for each feature or checklist/checklist-item
You must submit this as a written document, ideally in a tabular format, and it is suggested that you enter your checklists into an appropriate project management application to assist you in completing T1A2-10.

Your checklists for each feature should have at least 5 items.
task	Subtask	size	priority	Deadline
Start screen	Leaderboard option	Small	Essential	Thursday
	Start game option	Small	essential	Thursday
	Quit option	Smsall	ESSENTIAL	Thursday
	Start screen graphics	Medium	nice	Thursday
	Start screen sketch	Med	e	Tue
				
				
Gameplay	Bird graphics	Small	Essential	Tuesday
	Pipe graphics	Medium	Essential	Tuesday
	Background graphics	Medium	Nice	Thursday
	Jump mechanic	Large	Essential	Tuesday
	Render loop	Large	Essential	Tuesday
	Sketch of gameplay	Med	Es	Tue
	End when player hits pipe	small	Es	Tue
Score counter	Score keeping function	Small	E	Wednesday
	Counter in bottom left screen	Small	E	Wednesday
	Score variable to be saved later	small	E	Wednesday
	Update when player clears pipe	Small	e	Wed
				
				
				
leaderboard	Leaderboard layout sketch	Small	E	Tue
	hash of player names and scores 	Med	E	Wednesday
	Dummy data for demo	Small	N	Thur
	Update on end of game	Med	E	Wed
				
				
				
End screen	End screen sketch	Small	E	Tue
	Display score	Small	E	Wed
	Return to main menu button	Small	E	Wed
	Implement end screen graphics	Med	E	Thur
 
Sketches complete
 
Coding complete, on to documentation
