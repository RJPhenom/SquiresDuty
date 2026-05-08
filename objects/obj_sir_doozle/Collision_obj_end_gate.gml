// Sir Doozle has reached the end gate. Flip the global flag so Grizzelda can now win.
// (She still has to walk to the gate herself per the GDD.)
global.doozle_reached_end = true;

// Stop him cold so he stands at the gate looking smug instead of walking through and beyond.
walk_dir	= 0;
vel_x		= 0;
move_speed	= 0;
