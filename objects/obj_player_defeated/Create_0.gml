// Death-flop physics: light gravity + a small upward kick so she pops off the
// ground before falling out of the room (the existing Outside Room event triggers
// the room restart). Lighter pop than the template so the death anim is readable.
gravity	= 1.5;
vspeed	= -22;

// Don't flip — spr_grizzelda_death is authored facing the right direction.
image_xscale = 1;

// Start the pixelate transition timer.
alarm[0] = 30;

// Stop all playing audio, play her death cry, then the lose sting underneath.
audio_stop_all();
audio_play_sound(Grizzelda_Death, 0, 0);
audio_play_sound(snd_music_lose, 0, 0);
