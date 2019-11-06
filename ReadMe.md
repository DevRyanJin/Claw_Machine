For “hand code” the geometry part, I used QUADS to implement box with different-colored faces. I wrote this in ‘drawBox2’ function in my code.  

Every motion key will cause corresponding action to the machine until either it reaches its end or same key is pressed. But, one thing I want to clarify here is (If key is pressed ‘q’ -‘w’ -‘q’ in this order,  the rotation motion stops, because ‘q’ is pressed twice. My code stores whether certain key has been pressed or not, but this only affects same motion set( q -w   ,    e-r,      a-z,     s-d,     c-x ). 

The gripper is its maximum angle to open when program starts but the the special behavior of space bar starts with opening gripper and the animation is time-based sequence. So, need to wait couple second until it start next operation which is ‘drop cable’.  (only case for space bar is pressed when gripper is its maximum angle to open )


