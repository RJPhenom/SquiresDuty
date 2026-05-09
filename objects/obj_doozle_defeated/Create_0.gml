// Mirror obj_player_defeated's death-flop: small upward kick + gravity so the
// corpse pops, falls out of the room, and triggers the room restart from
// Outside Room. Doozle is heavier — slightly stronger gravity, slightly
// lighter pop than Grizzelda — so the read is a thudding fall vs her hop.
gravity	= 1.8;
vspeed	= -18;

// Don't flip — spr_doozle_death is authored facing the right direction.
image_xscale = 1;

// Start the pixelate transition timer.
alarm[0] = 30;

// Stop all playing audio and play the lose sting (his death = level fail).
audio_stop_all();
audio_play_sound(snd_music_lose, 0, 0);
