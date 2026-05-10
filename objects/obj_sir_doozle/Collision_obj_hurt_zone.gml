// Doozle hits a hurt zone (lava, spikes, pit floor). Mirrors the player's
// hurt-zone handling but scaled to his 100hp pool — 25 dmg per fall, so he
// can take ~4 unlucky pits before going down.
//
// Respawn pushes back from the edge opposite to his walk direction so he
// doesn't immediately march off again. 200px back is enough to avoid the
// "fall, respawn, fall, respawn" rapid-fire failure loop.
hp -= 25;

if (hp > 0)
{
	var _back_dir	= (walk_dir != 0) ? -sign(walk_dir) : -1;
	var _back_dist	= 200;
	x = grounded_x + _back_dir * _back_dist;
	y = grounded_y;

	vel_x = 0;
	vel_y = 0;

	audio_play_sound(snd_life_lost_01, 0, 0);
}
// If hp <= 0, obj_character_parent.End Step takes care of swapping in his
// defeated_object on the next frame.
