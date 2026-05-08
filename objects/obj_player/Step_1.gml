// Inherit parent Begin Step (gravity, friction, grounded check).
event_inherited();

if (jump_input)			player_jump();
if (left_input)			player_left();
if (right_input)		player_right();
if (cycle_next_input)	{ backpack_cycle( 1); cycle_next_input = false; }
if (cycle_prev_input)	{ backpack_cycle(-1); cycle_prev_input = false; }
if (use_input)			player_use();
