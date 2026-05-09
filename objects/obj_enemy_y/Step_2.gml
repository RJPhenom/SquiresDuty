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

// Face Sir Doozle so he visually tracks the knight (the actual threat that
// can shoot him down). Run AFTER the parent's flip so this overrides the
// vel_x-based auto-flip — important because at vel_x = 0 the parent leaves
// xscale alone, but if you ever turn Y back into a patroller this still wins.
// If Doozle is gone (defeated), we just hold the last facing direction.
if (instance_exists(obj_sir_doozle))
{
	image_xscale = (obj_sir_doozle.x < x) ? -1 : 1;
}
