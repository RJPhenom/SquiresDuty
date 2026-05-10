// Create a global particle system that is persistent, so it can be used throughout the game
global.part_system = part_system_create_layer("Instances", true);

// If the game is running on a browser, it changes the window and application surface
// size to fit the browser area. It uses the height to ensure the aspect ratio stays the same.
if (os_browser != browser_not_a_browser)
{
	var _aspect = 1920/1080;

	window_set_size(display_get_height() * _aspect, display_get_height());

	surface_resize(application_surface, display_get_height() * _aspect, display_get_height());

	display_set_gui_size(1920, 1080);
}

// Music starts in Other_4 (Room Start) — that handler picks the right track
// based on the current room and is_playing-checks to avoid restarts on
// level-to-level transitions.

// Set the falloff model used for all audio emitters, like in obj_end_gate
audio_falloff_set_model(audio_falloff_linear_distance_clamped);

// Set listener orientation for proper 3D audio
audio_listener_orientation(0, 0, 1000, 0, -1, 0);