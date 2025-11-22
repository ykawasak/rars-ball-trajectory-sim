# RISC-V Bouncing Ball Trajectory Simulation

This is a physics-based simulation of a bouncing ball's trajectory, written in RISC-V Assembly for the RARS (RISC-V Assembler and Runtime Simulator).

It calculates and draws the ball's path on the RARS Bitmap Display in real-time, based on an initial vertical speed provided by the user.

## Simulation Parameters
The program operates based on the following physical rules:

* **Gravity Acceleration:** 9.8 m/s²
* **Bounce:** The ball loses 1/16th of its kinetic energy upon each impact with the ground.
* **Time Step:** Position is calculated every 1/16th of a second (0.0625s).
* **Air Resistance:** None.

## 
## Technology Stack
* RISC-V Assembly Language
* RARS (utilizing the Bitmap Display tool)

## 
## How to Run
1.  Open the `.asm` file (e.g., `bouncing_ball.asm` or `main.asm`) in the RARS simulator.
2.  Go to the **Tools** menu and select **Bitmap Display**.
3.  In the Bitmap Display window, click the **"Connect to MIPS"** button.
4.  Click the **Run** icon (green play button) to assemble and run the program.
5.  {Describe how to input the initial speed here. e.g., "Enter a value in the console" or "Set the initial value in register a0".}
6.  The trajectory of the ball will be drawn on the Bitmap Display.
