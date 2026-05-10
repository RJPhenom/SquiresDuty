// GDD: "If Grizzelda scouts ahead and finds the end of the level she doesn't win.
//       Once Sir Doozle reaches the end, Grizzelda is allowed to enter and you win."
// So Grizzelda touching the gate only completes the level if Sir Doozle has already
// reached it (tracked via global.doozle_reached_end, set in obj_sir_doozle's
// collision with obj_end_gate).
if (!variable_global_exists("doozle_reached_end") || !global.doozle_reached_end)
{
	exit;
}

// Pass the SPECIFIC gate she hit so the fade walks toward it correctly even
// when the level has multiple gates (debug or otherwise).
var _end = instance_create_layer(x, y, layer, obj_player_end_level);
_end.target_gate = other.id;
instance_destroy();
