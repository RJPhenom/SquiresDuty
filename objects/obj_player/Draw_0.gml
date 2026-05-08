// Draw Grizzelda first (the engine no longer auto-draws when a Draw event exists).
draw_self();

var _n = array_length(backpack);
if (_n == 0) exit;

// Stack base sits just above her head (top of the bbox).
var _base_x	= x;
var _base_y	= bbox_top - 4;

// Treat the whole stack as a rigid arm pivoting at her shoulders. Each item
// sits stacked on the one below; the entire arm leans by `stack_tilt` degrees.
var _tilt_rad	= degtorad(stack_tilt);
var _sin_t		= sin(_tilt_rad);
var _cos_t		= cos(_tilt_rad);

var _running_h	= 0;
for (var i = 0; i < _n; i++)
{
	var _item	= backpack[i];
	var _spr	= _item.sprite;
	var _h		= _item.height;

	// Center of this item's slot, measured up the rotated stack axis.
	_running_h += _h * 0.5;
	var _ix = _base_x + _sin_t * _running_h;
	var _iy = _base_y - _cos_t * _running_h;
	_running_h += _h * 0.5;

	// Red equipped outline — drawn first so the item renders on top of it.
	if (i == equipped_index)
	{
		var _ow = sprite_get_width(_spr) * 0.55 + 4;
		var _oh = sprite_get_height(_spr) * 0.55 + 4;
		draw_set_color(c_red);
		draw_rectangle(_ix - _ow, _iy - _oh, _ix + _ow, _iy + _oh, false);
	}

	// Item sprite, leaned with the stack.
	draw_sprite_ext(_spr, 0, _ix, _iy, 1, 1, stack_tilt, c_white, 1);
}

draw_set_color(c_white);
