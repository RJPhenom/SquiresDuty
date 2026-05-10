// Restore ambient audio volumes
audio_sound_gain(snd_amb_cave_01, vol_cave_1, 0);

audio_sound_gain(snd_amb_cave_02, vol_cave_2, 0);

audio_sound_gain(snd_amb_trees, vol_trees, 0);

audio_sound_gain(snd_amb_wind, vol_wind, 0);

// Stop ambient audio (music is owned by obj_persistent_manager — let it
// keep handling track switches based on the next room).
audio_stop_sound(snd_amb_cave_01);

audio_stop_sound(snd_amb_cave_02);

audio_stop_sound(snd_amb_trees);

audio_stop_sound(snd_amb_wind);

// Restore the leaf count for the leaves effect — but only if Create actually
// found the EffectLeaf layer in this room. Without this guard, rooms that
// don't use the leaf effect (e.g. caves, old template rooms) crash on Game End
// because effect_leaf / leaf_count were never assigned.
if (layer_exists("EffectLeaf"))
{
	fx_set_parameter(effect_leaf, "param_num_particles", leaf_count);
}