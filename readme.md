Created for Field Programmable Gate Array Design (FPGA) Design class's final project.

The premise of the project was to create a robot that could move in four directions (up, right, left, down) to reach a target coordinate (xt, yt) from a starting point (x0, y0).
Obstacles are hard-coded in the file mazeFSM.vhd and can be updated to add more or less or change where they are in the maze.
Finally, the path taken by the robot will be displayed if robot successfully reaches the target, or displays "IMPOSSIBLE" if a path is not found.
Note that for certain cases, backtracking was not created successfully for the project.

### Instructions to operate board:

First, adjust switches to a binary value for the starting coordinates. First, the x starting coordinate would be taken, then hit
BTNU to switch and then get the starting y coordinate. LED's 4-7 would light up depending on the input being taken. Follow this pattern to get 
ending coordinates x and y. So, first x0, then BTNU, then y0, then BTNU, then x_target, BTNU, then y_target, then BTNU.
Then hit BTNR to start the movement on the robot, and once the program is done running, LD0 will light up to indicate
it's done. Then BTND can be pressed repeatedly to start going through the coordinates of the path taken and finally the total steps the robot took.
The LED1 will light up if the robot can't reach the final target due to impossible circumstances and display "IMPOSSIBLE". 

Buttons BTNL and BTNC are used to reset the maze FSM program and the OLED display respectively and should both be pressed before testing new cases.

### Instructions to generate bitstream: 
To change the maze grid, certain lines need to be uncommented in the mazeFSM.vhd file. First, the generic integer needs to change depending on the size of the array you want.

For our program, we only created 3x3, 5x5 or 8x8 maze, so the integer can change to 3, 5, or 8 depending on the size.

Then, you uncomment the type and signal (2 lines of code for each size) that are in the architecture of the maze_FSM.
For example, lines 38 and 39 should be uncommented if the 8x8 maze needs to be used, and the other mazes should be commented.

Lastly, for the obstacles, they are placed in the state s1, so for each maze there are two obstacles for each that can be commented/uncommented depending on the number of obstacles you want.
For example, if you just want one obstacle for the 8x8 maze, you then uncomment line 85 to place one obstacle.

### Instructions to generate simulation:
Following the changes made to mazeFSM.vhd to build the maze you want to simulate, next is uncommenting/commenting
the lines for the signal sw_input that gets passed into the switch_input input for the maze_FSM entity.

Each maze type has the same starting point, while the end point is different depending on the size. The signal sw_input can be changed
to whichever number you woud like.

An important note is that there is an initial '0' for the sw_input to accomodate timing, so if you want to change the numbers for the starting
and ending coordinates, start with the second sw_input on line 114 of mazeFSM_tb.

May need to extend timing for simulation to see it completely.

