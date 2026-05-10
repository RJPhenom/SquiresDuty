// Backpack stack draws FIRST so items render BEHIND Grizzelda — that way the
// stack doesn't cover her face/head when she's leaning forward into a heavy
// load. The character sprite is drawn last (at the bottom of this event).
var _n = array_length(backpack);

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

	// Equipped indicator — when an item is the equipped one, swap its sprite
	// for the matching glow variant (the new glow art bakes the full item +
	// halo into a single sprite). Items without a glow variant get a soft
	// red rectangle behind them so selection is still visible.
	var _draw_spr = _spr;
	var _drew_red_box = false;

	if (i == equipped_index)
	{
		switch (_item.type)
		{
			case "sword":		_draw_spr = spr_sword_glow;		break;
			case "shield":		_draw_spr = spr_shield_glow;	break;
			case "crossbow":	_draw_spr = spr_crossbow_glow;	break;

			case "jumpfruit":
			case "wood":
				// Programmatic glow — no dedicated glow sprite, so we fake
				// one by drawing the item sprite a few times with a small
				// radial offset, tinted yellow, BEFORE the real draw. Pulses
				// in alpha for life.
				var _pulse = 0.35 + 0.25 * sin(current_time * 0.006);
				for (var _ang = 0; _ang < 360; _ang += 60)
				{
					var _ox = lengthdir_x(4, _ang);
					var _oy = lengthdir_y(4, _ang);
					draw_sprite_ext(
						_spr, 0,
						_ix + _ox, _iy + _oy,
						1.12, 1.12,
						stack_tilt,
						c_yellow, _pulse
					);
				}
				break;

			default:
				// No glow art for this type — soft red rect fallback.
				var _ow = sprite_get_width(_spr) * 0.55 + 4;
				var _oh = sprite_get_height(_spr) * 0.55 + 4;
				draw_set_color(c_red);
				draw_set_alpha(0.45);
				draw_rectangle(_ix - _ow, _iy - _oh, _ix + _ow, _iy + _oh, false);
				draw_set_alpha(1);
				_drew_red_box = true;
				break;
		}
	}

	// Single item draw — either the base sprite, or the glow variant if equipped.
	draw_sprite_ext(_draw_spr, 0, _ix, _iy, 1, 1, stack_tilt, c_white, 1);
}

draw_set_color(c_white);

// Grizzelda renders LAST so the backpack stack appears behind her instead of
// covering her face when the stack tilts forward.
draw_self();

// --- DEBUG: hold F1 to see collision bboxes -------------------------------
// Draws outlined rectangles around the player's bbox AND every obj_collision
// child (floating blocks, bridges, placed wood) so you can visually see where
// the actual hit-test geometry is. Useful for tuning bridge/plank seams.
//   green  = player bbox
//   red    = obj_collision children (bridges, walls, placed wood, etc.)
if (keyboard_check(vk_f1))
{
	draw_set_alpha(0.65);

	draw_set_color(c_lime);
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

	draw_set_color(c_red);
	with (obj_collision)
	{
		draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
	}

	draw_set_alpha(1);
	draw_set_color(c_white);
}
