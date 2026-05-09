// Override obj_enemy_parent.End Step. We still want hp<=0 → defeat and
// invincibility flashing (in obj_character_parent), but we replace the
// vanilla wander/wall-flip with a "chase if visible, else hold" pattern.
event_perform_object(obj_character_parent, ev_step, ev_step_end);

// --- Target selection: Doozle priority, Grizzelda fallback -------------------
var _chase_range_x	= 600;
var _chase_range_y	= 200;
var _target			= noone;

if (instance_exists(obj_sir_doozle))
{
	var _dx = obj_sir_doozle.x - x;
	var _dy = abs(obj_sir_doozle.y - y);
	if (abs(_dx) <= _chase_range_x && _dy <= _chase_range_y)
	{
		_target = instance_find(obj_sir_doozle, 0);
	}
}

if (_target == noone && instance_exists(obj_player))
{
	var _dx = obj_player.x - x;
	var _dy = abs(obj_player.y - y);
	if (abs(_dx) <= _chase_range_x && _dy <= _chase_range_y)
	{
		_target = instance_find(obj_player, 0);
	}
}

// --- Pursuit or hold ----------------------------------------------------------
if (_target != noone)
{
	// Walk toward target, but stop at walls/ledges so we don't suicide off
	// cliffs. "Stand and glare" is the failure mode when he can't reach.
	var _facing = sign(_target.x - x);
	if (_facing == 0) _facing = 1;
	var _wall = check_collision(_facing * 4, 0);
	var _ground = check_collision(_facing * 32, 64);
	if (_wall || (!_ground && grounded))
	{
		vel_x = 0;
	}
	else
	{
		vel_x = _facing * move_speed;
	}
}
else
{
	// No target in range — hold position.
	vel_x = 0;
}
