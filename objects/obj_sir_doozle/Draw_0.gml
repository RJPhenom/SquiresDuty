// Draw Sir Doozle himself (engine no longer auto-draws when a Draw event exists).
draw_self();

// Then his equipped item, gripped in front of him at chest height.
if (equipped_item == undefined) exit;

// Hand offset relative to his sprite origin. Tuned by eye for the current
// 64x64-ish character size; tweak _hand_dx / _hand_dy when art changes.
var _hand_dx = 22 * image_xscale;	// forward (flips with him)
var _hand_dy = -10;					// just above his hip / mid-chest

var _hx = x + _hand_dx;
var _hy = y + _hand_dy;

// Item sprite is flipped to match his facing.
draw_sprite_ext(
	equipped_item.sprite, 0,
	_hx, _hy,
	image_xscale, 1,
	0, c_white, 1
);

// While actively swinging, briefly inflate the item to sell the hit. Triggered
// just after a swing fires (when combat_swing_timer is near full).
if (fighting && combat_swing_timer > combat_swing_period - 8)
{
	draw_sprite_ext(
		equipped_item.sprite, 0,
		_hx, _hy,
		image_xscale * 1.25, 1.25,
		0, c_white, 0.5
	);
}
