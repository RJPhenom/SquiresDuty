// Tick the cooldown regardless of whether we have a target — keeps the cadence
// even, no "first shot fires the instant you walk into range" issue.
fire_cooldown -= 1;

// Doozle is the priority target — he's the threat that fights back. Only
// fall through to Grizzelda if Doozle is dead or out of sight band.
var _target = noone;

with (obj_sir_doozle)
{
	var _dx = abs(x - other.x);
	var _dy = abs(y - other.y);
	if (_dy <= other.fire_y_band && _dx <= other.fire_range)
	{
		_target = id;
	}
}

if (_target == noone)
{
	with (obj_player)
	{
		var _dx = abs(x - other.x);
		var _dy = abs(y - other.y);
		if (_dy <= other.fire_y_band && _dx <= other.fire_range)
		{
			_target = id;
		}
	}
}

if (_target == noone) exit;
if (fire_cooldown > 0) exit;

// Face the target so his sprite flips toward where the arrow goes.
image_xscale = (_target.x < x) ? -1 : 1;

// Spawn arrow heading at the target. We aim from the archer's chest toward the
// target's chest so arrows don't graze the floor on long shots.
var _ax = x;
var _ay = y - 24;
var _dir = point_direction(_ax, _ay, _target.x, _target.y - 24);
var _arrow = instance_create_layer(_ax, _ay, "Instances", obj_arrow);
_arrow.team			= "enemy";
_arrow.damage		= 1;	// hp delta is in player-heart currency, see obj_arrow
_arrow.vel_x		= lengthdir_x(arrow_speed, _dir);
_arrow.vel_y		= lengthdir_y(arrow_speed, _dir);
_arrow.image_angle	= _dir;
_arrow.image_xscale	= sign(_arrow.vel_x);
if (_arrow.image_xscale == 0) _arrow.image_xscale = 1;

audio_play_sound(Arrow, 0, 0);

fire_cooldown = fire_period;
