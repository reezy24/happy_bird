# Development Log

## Tuesday
Refreshing myself on what flappy bird looked like
![flappy bird screenshot 1](https://github.com/reezy24/happy_bird/blob/master/images/flap1.png)
![flappy bird screenshot 2](https://github.com/reezy24/happy_bird/blob/master/images/flap2.png)

 
Brainstorming how I would layout the screen:
•	Is there a way to set the screen size from within IRB?
•	Is there a way to hide the prompt? 
•	I will likely need to clear the screen many times
•	Potential issue if terminal window launches at a different size between machines

Proof of concept for graphics:
![pipe graphics 1](https://github.com/reezy24/happy_bird/blob/master/images/j1.png)
![pipe graphics 2](https://github.com/reezy24/happy_bird/blob/master/images/j2.png)

Trying to print a continuous line of ground, does this instead:
![issue 1](https://github.com/reezy24/happy_bird/blob/master/images/j3.png)

•	So need to check that position of bird is greater than height of bottom pipe but less than height of top pipe

Render loop planning:
•	Iterate through each line for the number of columns
•	Check if that column should be whitespace, pipe, bird or ground
•	Update character within that pipe accordingly
•	Need a trigger for when to start rendering a new pipe

Initially only printed blank lines:
![issue 2](https://github.com/reezy24/happy_bird/blob/master/images/j4.png)

Next result is a bit better, though the same line needs to be updated instead of a new line every time
![issue 3](https://github.com/reezy24/happy_bird/blob/master/images/j5.png)

This code produced a suitable result:
![code 1](https://github.com/reezy24/happy_bird/blob/master/images/j6.png)
![gif 1](https://github.com/reezy24/happy_bird/blob/master/images/render%20loop%20test%201.gif)

## Wednesday
Creating pipe graphics
![code 2](https://github.com/reezy24/happy_bird/blob/master/images/j9.png)
![code 3](https://github.com/reezy24/happy_bird/blob/master/images/j10.png)

Now change the render loop such that the screen appears to be moving right to left
•	Get an offset that can be a maximum of the size of the pipe head graphic, since the pipes are repeating patterns
•	Modify the loop so that the lines are printed based on this offset
•	This offset is either increased or reset every gameloop
•	We’ll need an extra pipe in the pipe array to render the “next” pipe which will be off-screen at the start
•	When the offset is reverted to 0, the pipe array should be shifted since the first pipe is now off screen
•	We can draw the row with all five pipes and cut off the end as needed later on

![gif 2](https://github.com/reezy24/happy_bird/blob/master/images/render%20loop%20second%20test.gif)

Scrolling screen with randomly generated pipes now works
![code 4](https://github.com/reezy24/happy_bird/blob/master/images/j11.png)
![gif 3](https://github.com/reezy24/happy_bird/blob/master/images/render%20loop%20third%20test.gif)

Status update: Scrolling works, though screen flashes frequently due to calling the clear method. Apparently the gem “curses" should fix this.
Errors installing curses:
•	Sudo apt-get update
•	Sudo apt-get build-essential
•	Sudo apt-get ruby-dev

## Thursday

Testing "jump" for bird just using the terminal cursor:
![gif 4](https://github.com/reezy24/happy_bird/blob/master/images/bird%20jump%20test.gif)

Now that the bird graphics works, it’s time to combine the pipe graphics with the bird graphics. 
![gif 5](https://github.com/reezy24/happy_bird/blob/master/images/combine%20bird%20jump%20with%20pipes.gif)

Status update – after refactoring the code, the flickering has returned. 
Statue update – fixed flickering somewhat, had to create a new window instead of using the current one. 
Could potentially only update screen once the first pipe has completely disappeared. Will apply bird first though. 
So the bird and the pipes have now been combined, though the flickering is back and it’s worse… potentially a performance issue. Could try out “pad” part of curses as well.

## Friday
•	Fixed flickering with loop optimisations
•	Added colours
•	Cleaned up menus
•	Refactored
