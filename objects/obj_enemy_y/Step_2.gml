// Override obj_enemy_parent.End Step. We still want hp<=0 → defeat and
// invincibility flashing (in obj_character_parent), and we want sprite flipping
// based on vel_x. We DON'T want the ledge-detection turn (he's flying — there's
// no ledge under him in any meaningful sense). We DO want a wall turn so he
// doesn't ram terrain forever.
event_perform_object(obj_character_parent, ev_step, ev_step_end);

// Flip on wall.
if (place_meeting(x + vel_x * 4, y, obj_collision))
{
	vel_x = -vel_x;
}

// Facing: while diving, lead with the dive_target so the swoop reads cleanly.
// At rest or returning, face Sir Doozle so the visual still cues "the threat
// the knight should worry about" rather than randomly flipping with the bob.
// Holds last facing if both targets are gone.
var _face_target = noone;
if (state == "dive" && dive_target != noone && instance_exists(dive_target))
{
	_face_target = dive_target;
}
else
{
	_face_target = instance_find(obj_sir_doozle, 0);
}

if (_face_target != noone)
{
	image_xscale = (_face_target.x < x) ? -1 : 1;
}
