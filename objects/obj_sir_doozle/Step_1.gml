// Inherit parent Begin Step (gravity, friction, grounded check).
event_inherited();

// Auto-jump when blocked by a wall: if there's a collision one body-width ahead
// at standing height, hop. Lets him climb small ledges instead of getting stuck
// on geometry — he side-scrolls "independently" of the player but isn't suicidal
// when the level forces him over a single tile.
if (grounded && walk_dir != 0)
{
	// Look ahead about 8px in his walking direction at his current Y.
	if (check_collision(walk_dir * 8, 0))
	{
		vel_y		= -jump_speed;
		grounded	= false;
		sprite_index = spr_doozle_jump;
		image_index	= 0;

		// Reuse Grizzelda's jump SFX with a deeper pitch — he's a bigger guy.
		var _sound = audio_play_sound(snd_jump, 0, 0);
		audio_sound_pitch(_sound, random_range(0.55, 0.7));
	}
}
