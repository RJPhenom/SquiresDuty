// Draw the sprite at the instance position plus visual_y_offset. The instance's
// actual x/y is what bbox/place_meeting use, so this purely shifts the visual
// without affecting collision — handy for nudging the wood plank to match the
// surrounding platform top after the bbox-inset trick puts collision a pixel
// off from where the sprite "wants" to render.
draw_sprite_ext(
	sprite_index, image_index,
	x, y + visual_y_offset,
	image_xscale, image_yscale,
	image_angle, image_blend, image_alpha
);
