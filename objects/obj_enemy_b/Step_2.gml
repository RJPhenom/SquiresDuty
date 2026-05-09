// Override obj_enemy_parent.End Step. We still want hp<=0 → defeat and
// invincibility flashing (in obj_character_parent), but we replace the
// vanilla wander/wall-flip with a "chase Doozle if visible, otherwise
// wander" pattern.
event_perform_object(obj_character_parent, ev_step, ev_step_end);

// --- Detection ---
var _chase_range_x = 600;
var _chase_range_y = 200;
var _chasing = false;

if (instance_exists(obj_sir_doozle))
{
	var _dx = obj_sir_doozle.x - x;
	var _dy = abs(obj_sir_doozle.y - y);

	if (abs(_dx) <= _chase_range_x && _dy <= _chase_range_y)
	{
		// Set vel_x toward Doozle, but stop at ledges/walls so B doesn't
		// suicide off cliffs in pursuit. Stand-and-glare is the failure
		// mode when he can't reach.
		var _facing = sign(_dx);
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
		_chasing = true;
	}
}

// --- Wander fallback (mirror of obj_enemy_parent.Step_2 wall/ledge turns) ---
if (!_chasing)
{
	if (vel_x == 0) vel_x = move_speed;	// kickstart if we just left chase

	if (check_collision(vel_x * 4, 0))
	{
		vel_x = -vel_x;
	}

	if (!check_collision(vel_x * 32, 64) && grounded)
	{
		vel_x = -vel_x;
	}

	// Avoid running through other enemies — same as parent.
	if (instance_place(x + vel_x * 16, y, obj_enemy_parent) != noone)
	{
		vel_x = -vel_x;
	}
}
