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

// --- Swing animation (sword only) -----------------------------------------------
// Drives the sword's image_angle from combat_swing_timer so the chop arcs
// through a windup → strike → follow-through cycle whenever do_swing fires.
// Other equipped items (shield, crossbow, etc.) hold a static idle pose since
// they don't visually swing.
//
// combat_swing_timer counts DOWN from combat_swing_period (60). Right after a
// swing fires it resets to 60, so frames_since_swing starts at 0 and grows.
var _angle			= 0;
var _strike_flash	= false;

if (equipped_item.type == "sword")
{
	var _frames_since_swing	= combat_swing_period - combat_swing_timer;
	var _swing_window		= 14;	// ~14 frames of visible motion (~0.23s)

	// Pose angles, expressed as if facing right. Mirrored below for image_xscale = -1.
	//   idle  — sword tilted up-forward, resting position
	//   peak  — windup, sword raised back/over the head
	//   end   — follow-through, sword chopped down-forward
	var _idle_angle	= 30;
	var _peak_angle	= 130;
	var _end_angle	= -55;

	if (fighting && _frames_since_swing < _swing_window)
	{
		var _t = _frames_since_swing / _swing_window;	// 0..1 across the chop
		if (_t < 0.35)
		{
			// Windup phase — quick raise from idle to peak.
			_angle = lerp(_idle_angle, _peak_angle, _t / 0.35);
		}
		else
		{
			// Strike + follow-through — peak chops down to end pose.
			_angle = lerp(_peak_angle, _end_angle, (_t - 0.35) / 0.65);
			// Hit-punch flash fires during the first half of the strike,
			// when the blade is sweeping through the contact arc.
			_strike_flash = (_t < 0.65);
		}
	}
	else
	{
		_angle = _idle_angle;
	}
}

// Mirror the angle when he's facing left so the chop reads correctly either way.
var _draw_angle = _angle * image_xscale;

// Item sprite, rotated for the current swing phase.
draw_sprite_ext(
	equipped_item.sprite, 0,
	_hx, _hy,
	image_xscale, 1,
	_draw_angle, c_white, 1
);

// Brief inflated ghost during the strike — sells the hit even before the
// damage number lands. Same idea as before, just gated on the strike phase
// instead of the whole post-fire window.
if (_strike_flash)
{
	draw_sprite_ext(
		equipped_item.sprite, 0,
		_hx, _hy,
		image_xscale * 1.3, 1.3,
		_draw_angle, c_white, 0.5
	);
}
