// Here we're getting the X position of the mouse on the GUI layer.
// The Draw GUI event is used to draw the button, which is a separate layer
// on top of the game. So input for these buttons must also be taken on the GUI layer.
var _mouse_gui_x = device_mouse_x_to_gui(0);

// Get the Y position of the mouse on the GUI layer
var _mouse_gui_y = device_mouse_y_to_gui(0);

// Check if the mouse point is colliding with this instance (using 'id').
// This means the mouse is hovering on the button.
if (collision_point(_mouse_gui_x, _mouse_gui_y, object_index, false, false) == id)
{
	// If it is, change the frame to the hover frame (1)
	image_index = 1;

	// If the left mouse button is pressed,
	if (mouse_check_button_pressed(mb_left))
	{
		// Squish to 90% of the resting scale while held.
		image_xscale = natural_scale_x * 0.9;
		image_yscale = natural_scale_y * 0.9;
	}

	// If the left mouse button is released (which is when we register a click),
	if (mouse_check_button_released(mb_left))
	{
		// Change the frame to the idle frame (0)
		image_index = 0;
	
		// Call User Event 0 where the button performs its actions
		event_user(0);
	
		// Snap back to the resting scale.
		image_xscale = natural_scale_x;
		image_yscale = natural_scale_y;

		// Play the button press sound effect
		audio_play_sound(Confirm, 0, 0);
	}
}
// If the mouse is not hovering,
else
{
	// Change the frame to the idle frame (0)
	image_index = 0;

	// Snap back to the resting scale.
	image_xscale = natural_scale_x;
	image_yscale = natural_scale_y;
}