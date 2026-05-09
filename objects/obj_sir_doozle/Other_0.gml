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
		x = grounded_x;
		y = grounded_y;

		vel_x = 0;
		vel_y = 0;

		audio_play_sound(snd_life_lost_01, 0, 0);
	}
}
