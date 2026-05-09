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

	// Equipped indicator — draw the matching glow sprite UNDER the item so the
	// item silhouette shows on top. Glow sprites are origin-aligned to their
	// item sprites, so they overlay perfectly when drawn at the same point.
	// Items without a glow (potion, wood, jumpfruit, coin, …) fall back to the
	// soft red outline so selection is still visible.
	if (i == equipped_index)
	{
		var _glow = -1;
		switch (_item.type)
		{
			case "sword":		_glow = spr_sword_glow;		break;
			case "shield":		_glow = spr_shield_glow;	break;
			case "crossbow":	_glow = spr_crossbow_glow;	break;
		}

		if (_glow != -1)
		{
			// Subtle pulse so the highlight reads as "selected" not "static art".
			var _pulse = 0.85 + 0.15 * sin(current_time * 0.006);
			draw_sprite_ext(_glow, 0, _ix, _iy, 1, 1, stack_tilt, c_white, _pulse);
		}
		else
		{
			var _ow = sprite_get_width(_spr) * 0.55 + 4;
			var _oh = sprite_get_height(_spr) * 0.55 + 4;
			draw_set_color(c_red);
			draw_set_alpha(0.45);
			draw_rectangle(_ix - _ow, _iy - _oh, _ix + _ow, _iy + _oh, false);
			draw_set_alpha(1);
		}
	}

	// Item sprite, leaned with the stack.
	draw_sprite_ext(_spr, 0, _ix, _iy, 1, 1, stack_tilt, c_white, 1);
}

draw_set_color(c_white);
