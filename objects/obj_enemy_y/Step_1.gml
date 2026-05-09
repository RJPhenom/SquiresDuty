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

		// Trigger dive — check Grizzelda first (priority target), then
		// Doozle if she's out of cone. dive_target is the picked instance.
		dive_target = noone;

		var _candidate = instance_find(obj_player, 0);
		if (_candidate != noone)
		{
			var _dx = _candidate.x - x;
			var _dy = _candidate.y - y;
			if (abs(_dx) <= dive_trigger_x && _dy >= dive_min_dy && _dy <= dive_max_dy)
			{
				dive_target = _candidate;
			}
		}

		if (dive_target == noone)
		{
			_candidate = instance_find(obj_sir_doozle, 0);
			if (_candidate != noone)
			{
				var _dx = _candidate.x - x;
				var _dy = _candidate.y - y;
				if (abs(_dx) <= dive_trigger_x && _dy >= dive_min_dy && _dy <= dive_max_dy)
				{
					dive_target = _candidate;
				}
			}
		}

		if (dive_target != noone) state = "dive";
		break;

	case "dive":
		// Target may have died/despawned mid-dive; abort to return.
		if (dive_target == noone || !instance_exists(dive_target))
		{
			state = "return";
			break;
		}

		var _dir = point_direction(x, y, dive_target.x, dive_target.y);
		x += lengthdir_x(dive_speed, _dir);
		y += lengthdir_y(dive_speed, _dir);

		// Hit check. Doozle has no enemy-collision event of his own, so
		// damage is applied in-line if he's the target. Grizzelda's
		// existing Collision_obj_enemy_parent fires automatically on
		// overlap — we just peel off when she's been touched.
		if (place_meeting(x, y, dive_target))
		{
			if (dive_target.object_index == obj_sir_doozle)
			{
				dive_target.hp -= dive_damage;
				audio_play_sound(snd_enemy_hit, 0, 0);
			}
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
