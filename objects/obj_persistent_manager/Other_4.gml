// Music routing — single source of truth for which track plays in each
// context. Only swaps when the context changes; gameplay music plays
// continuously across level-to-level transitions because we don't restart
// it if it's already playing.
//
// rm_menu             → Squire_Title_RTv1
// rm_cutscene_intro   → silence (video has its own audio)
// rm_end              → (nothing for now; end music is WIP)
// everything else (gameplay levels) → Squire_gameplay_RT_v1
if (room == rm_menu)
{
	if (!audio_is_playing(Squire_Title_RTv1))
	{
		audio_stop_sound(Squire_gameplay_RT_v1);
		audio_play_sound(Squire_Title_RTv1, 0, true);
	}
}
else if (room == rm_cutscene_intro)
{
	// Cutscene rooms — silence game music so the video's own audio comes
	// through clean. The cutscene player object also calls audio_stop_all
	// belt-and-suspenders.
	audio_stop_sound(Squire_Title_RTv1);
	audio_stop_sound(Squire_gameplay_RT_v1);
}
else if (room == rm_end)
{
	// TODO: when end-screen track is imported, swap this for that.
	audio_stop_sound(Squire_Title_RTv1);
	audio_stop_sound(Squire_gameplay_RT_v1);
}
else
{
	if (!audio_is_playing(Squire_gameplay_RT_v1))
	{
		audio_stop_sound(Squire_Title_RTv1);
		audio_play_sound(Squire_gameplay_RT_v1, 0, true);
	}
}