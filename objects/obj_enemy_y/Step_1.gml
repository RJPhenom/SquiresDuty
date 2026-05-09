// Override obj_character_parent.Begin Step. Fliers don't use gravity or
// friction, so we deliberately DON'T call event_inherited() — instead we
// drive position via the dive state machine.
grounded = false;

switch (state)
{
	case "hover":
		// Bob at spawn altitude.
		bob_t += 4;
		x = spawn_x;
		y = spawn_y + sin(degtorad(bob_t)) * bob_amplitude;

		// Trigger dive when Doozle is below us in a tight horizontal cone.
		if (instance_exists(obj_sir_doozle))
		{
			var _dx = obj_sir_doozle.x - x;
			var _dy = obj_sir_doozle.y - y;
			if (abs(_dx) <= dive_trigger_x && _dy >= dive_min_dy && _dy <= dive_max_dy)
			{
				state = "dive";
			}
		}
		break;

	case "dive":
		// Track Doozle's current position so a moving knight is harder to
		// hit but still gets snapped at. If he's gone (defeated mid-dive),
		// abort to return.
		if (!instance_exists(obj_sir_doozle))
		{
			state = "return";
			break;
		}

		var _dir = point_direction(x, y, obj_sir_doozle.x, obj_sir_doozle.y);
		x += lengthdir_x(dive_speed, _dir);
		y += lengthdir_y(dive_speed, _dir);

		// Hit check: deal damage on contact, then peel off. Doozle has no
		// own-side collision event for enemies, so we apply the damage here.
		if (place_meeting(x, y, obj_sir_doozle))
		{
			obj_sir_doozle.hp -= dive_damage;
			audio_play_sound(snd_enemy_hit, 0, 0);
			state = "return";
			break;
		}

		// Bail if we've descended too far (clean miss) or hit terrain.
		if (y - spawn_y > dive_max_dy || place_meeting(x, y, obj_collision))
		{
			state = "return";
		}
		break;

	case "return":
		// Climb back toward spawn position; smooth approach so he eases in
		// rather than teleporting.
		var _ddx = spawn_x - x;
		var _ddy = spawn_y - y;
		var _dist = point_distance(x, y, spawn_x, spawn_y);
		if (_dist <= return_speed)
		{
			x = spawn_x;
			y = spawn_y;
			state = "hover";
		}
		else
		{
			x += (_ddx / _dist) * return_speed;
			y += (_ddy / _dist) * return_speed;
		}
		break;
}
