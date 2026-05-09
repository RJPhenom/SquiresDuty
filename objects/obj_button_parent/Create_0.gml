// text: The text that will be displayed on this button
text = "Button";
// text_color: The color of the text on this button
text_color = c_white;

// Capture the scale set in the room editor as the "resting" scale. Step_1's
// hover/press logic scales relative to this instead of snapping to a hardcoded
// 1.0 (which would ignore whatever scale the instance was placed at).
natural_scale_x = image_xscale;
natural_scale_y = image_yscale;