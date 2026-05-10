// Outside Room — Doozle fell off the bottom of the level (room with no hurt
// zone at the floor, or his own version of "I walked off the edge"). Same
// damage/respawn pattern as Collision_obj_hurt_zone so the failure mode is
// consistent regardless of whether the level designer dropped a hurt zone in
// the pit or not.
if (bbox_top > room_height)
{
	hp -= 25;

	if (hp > 0)
	{
		// Same back-from-edge respawn as Collision_obj_hurt_zone.
		var _back_dir	= (walk_dir != 0) ? -sign(walk_dir) : -1;
		var _back_dist	= 200;
		x = grounded_x + _back_dir * _back_dist;
		y = grounded_y;

		vel_x = 0;
		vel_y = 0;

		audio_play_sound(Damage_2, 0, 0);
	}
}
