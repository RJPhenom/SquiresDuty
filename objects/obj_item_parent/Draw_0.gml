// Real per-item sprites are now in. Just draw the assigned sprite with a tiny
// vertical bob and a soft shadow. Children that need extra flourish can override.
var _bob = sin(degtorad(bob_t)) * 3;

draw_set_alpha(0.25);
draw_set_color(c_black);
var _half = sprite_width * 0.45;
draw_ellipse(x - _half, bbox_bottom + 1, x + _half, bbox_bottom + 5, false);
draw_set_alpha(1);
draw_set_color(c_white);

draw_sprite_ext(sprite_index, image_index, x, y + _bob, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
