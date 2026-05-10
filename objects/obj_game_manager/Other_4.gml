// Get the CollisionTiles layer tilemap ID
collision_tilemap = layer_tilemap_get_id("CollisionTiles");

// Music is handled in obj_persistent_manager.Other_4 — single source of
// truth across rooms so gameplay music doesn't restart at every level
// transition. We only manage per-room ambient audio here.

// Play ambient audio with looping enabled
audio_play_sound(snd_amb_trees, 0, 1);

audio_play_sound(snd_amb_wind, 0, 1);

audio_play_sound(snd_amb_cave_01, 0, 1);

// You're probably wondering why we're playing so many looping ambient tracks at once... It's so we can get
// them started once and then change their gains (volume) depending on where the player is in-game. See User Event
// 0 for that.
audio_play_sound(snd_amb_cave_02, 0, 1);

// Get the volumes for these sound assets so we know what volume value to use for each one of them, when managing
// their volumes later
vol_trees = audio_sound_get_gain(snd_amb_trees);

vol_wind = audio_sound_get_gain(snd_amb_wind);

vol_cave_1 = audio_sound_get_gain(snd_amb_cave_01);

vol_cave_2 = audio_sound_get_gain(snd_amb_cave_02);

// Set all cave audio to be muted, as we know the player starts out in the forest
audio_sound_gain(snd_amb_cave_01, 0, 0);

audio_sound_gain(snd_amb_cave_02, 0, 0);