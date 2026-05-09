// Doozle hits a hurt zone (lava, spikes, pit floor). Mirrors the player's
// hurt-zone handling but scaled to his 100hp pool — 25 dmg per fall, so he
// can take ~4 unlucky pits before going down. Respawn at his last grounded
// position so he doesn't immediately fall back in.
hp -= 25;

if (hp > 0)
{
	x = grounded_x;
	y = grounded_y;

	vel_x = 0;
	vel_y = 0;

	audio_play_sound(snd_life_lost_01, 0, 0);
}
// If hp <= 0, obj_character_parent.End Step takes care of swapping in his
// defeated_object on the next frame.
