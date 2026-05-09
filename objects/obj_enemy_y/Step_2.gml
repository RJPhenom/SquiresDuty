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
