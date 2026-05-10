// Off-screen indicator for Sir Doozle, drawn on the GUI layer.
// Yoshi's Island-style: a small bubble pinned to the screen edge nearest the knight,
// with an arrow on its outside pointing toward where he actually is.

// If the knight isn't in the room (not yet placed, or destroyed), nothing to indicate.
if (!instance_exists(obj_sir_doozle))
{
	exit;
}

// Use the first instance — there's normally only one knight.
var _knight = instance_find(obj_sir_doozle, 0);

// World-space camera rectangle (the gameplay view).
var _cam		= view_camera[0];
var _cam_x		= camera_get_view_x(_cam);
var _cam_y		= camera_get_view_y(_cam);
var _cam_w		= camera_get_view_width(_cam);
var _cam_h		= camera_get_view_height(_cam);

// Is the knight inside the visible camera rectangle? If so, no indicator needed.
var _on_screen = (_knight.x >= _cam_x && _knight.x <= _cam_x + _cam_w
				&& _knight.y >= _cam_y && _knight.y <= _cam_y + _cam_h);

if (_on_screen)
{
	exit;
}

// GUI surface dimensions (HUD coordinate space).
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Convert the knight's world position into GUI space, then clamp the bubble to the edge.
// Same scale factor for X and Y assumed (the project uses a fixed-aspect view → GUI mapping).
var _scale_x	= _gui_w / _cam_w;
var _scale_y	= _gui_h / _cam_h;
var _knight_gui_x = (_knight.x - _cam_x) * _scale_x;
var _knight_gui_y = (_knight.y - _cam_y) * _scale_y;

// Padding from the screen edge so the bubble isn't flush against it.
var _pad		= 48;
var _bubble_x	= clamp(_knight_gui_x, _pad, _gui_w - _pad);
var _bubble_y	= clamp(_knight_gui_y, _pad, _gui_h - _pad);

// Direction from the bubble's clamped position toward the knight's true position.
// This is what the arrow points along.
var _dx			= _knight_gui_x - _bubble_x;
var _dy			= _knight_gui_y - _bubble_y;
var _dir		= point_direction(_bubble_x, _bubble_y, _knight_gui_x, _knight_gui_y);

// Save draw state so we don't pollute later draws.
var _old_color	= draw_get_color();
var _old_alpha	= draw_get_alpha();

// --- Bubble body ---------------------------------------------------------------
// Pick the bubble sprite by Doozle's hp tier — same threshold as the HP bar
// color shifts (>60% green, >30% yellow, else red). At-a-glance health triage
// when he's off-screen.
var _frac = _knight.hp / _knight.max_hp;
var _bubble_spr;
if (_frac > 0.6)		_bubble_spr = spr_doozle_bubble_green;
else if (_frac > 0.3)	_bubble_spr = spr_doozle_bubble_yellow;
else					_bubble_spr = spr_doozle_bubble_red;

// Visual radius — sprite scales to fit a 2*radius square centered on
// (_bubble_x, _bubble_y). Smaller than the source 154px so the indicator
// reads as a HUD pip, not a banner.
var _radius	= 40;
var _spr_w	= sprite_get_width(_bubble_spr);
var _scale	= (_radius * 2) / _spr_w;

// Soft drop-shadow.
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_circle(_bubble_x + 3, _bubble_y + 4, _radius, false);
draw_set_alpha(1);

// Bubble sprite (origin is (0,0) on these — top-left — so we shift by
// -_radius on each axis to draw it centered on the bubble position).
draw_sprite_ext(
	_bubble_spr, 0,
	_bubble_x - _radius, _bubble_y - _radius,
	_scale, _scale,
	0, c_white, 1
);

// --- Arrow on the outside, pointing at the knight ------------------------------
// Tip sits just outside the bubble; base is the chord across the bubble's edge.
var _tip_dist	= _radius + 22;
var _base_dist	= _radius - 2;
var _base_half	= 14;

var _tip_x	= _bubble_x + lengthdir_x(_tip_dist, _dir);
var _tip_y	= _bubble_y + lengthdir_y(_tip_dist, _dir);

var _b1x	= _bubble_x + lengthdir_x(_base_dist, _dir + 90)  + lengthdir_x(_base_half * 0, _dir);
var _b1y	= _bubble_y + lengthdir_y(_base_dist, _dir + 90)  + lengthdir_y(_base_half * 0, _dir);
var _b2x	= _bubble_x + lengthdir_x(_base_dist, _dir - 90)  + lengthdir_x(_base_half * 0, _dir);
var _b2y	= _bubble_y + lengthdir_y(_base_dist, _dir - 90)  + lengthdir_y(_base_half * 0, _dir);

// Pull the base points toward the tip by half the base width so the triangle is correctly proportioned.
_b1x = _bubble_x + lengthdir_x(_base_dist + 4, _dir) + lengthdir_x(_base_half, _dir + 90);
_b1y = _bubble_y + lengthdir_y(_base_dist + 4, _dir) + lengthdir_y(_base_half, _dir + 90);
_b2x = _bubble_x + lengthdir_x(_base_dist + 4, _dir) + lengthdir_x(_base_half, _dir - 90);
_b2y = _bubble_y + lengthdir_y(_base_dist + 4, _dir) + lengthdir_y(_base_half, _dir - 90);

// Filled white arrow with black outline.
draw_set_color(c_white);
draw_triangle(_tip_x, _tip_y, _b1x, _b1y, _b2x, _b2y, false);
draw_set_color(c_black);
draw_triangle(_tip_x, _tip_y, _b1x, _b1y, _b2x, _b2y, true);

// (Icon is now the bubble sprite itself — no inset text needed.)

// Restore draw state.
draw_set_color(_old_color);
draw_set_alpha(_old_alpha);
