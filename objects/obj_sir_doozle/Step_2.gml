// Run the parent End Step (sprite flipping, defeat handling, invincibility flashing).
event_inherited();

// --- Combat detection: is there an enemy he can/should engage right now? -------
// Two modes:
//   melee — sword/shield/fists/jumpfruit/wood — look 6px ahead at body height.
//   ranged — crossbow — scan ranged_check_radius around him (any direction)
//            so he can engage R archers down the way and Y fliers overhead.
// We always prefer the closer threat in ranged mode.
var _enemy = noone;
var _has_crossbow = (equipped_item != undefined && equipped_item.type == "crossbow");

if (_has_crossbow)
{
	var _best_d = ranged_check_radius;
	with (obj_enemy_parent)
	{
		if (hp <= 0) continue;
		var _d = point_distance(x, y, other.x, other.y);
		if (_d <= _best_d)
		{
			_enemy = id;
			_best_d = _d;
		}
	}
}
else if (walk_dir != 0)
{
	_enemy = instance_place(x + walk_dir * melee_check_dist, y, obj_enemy_parent);
}

if (_enemy != noone && _enemy.hp > 0)
{
	fighting = true;
	vel_x = 0;

	combat_swing_timer -= 1;
	if (combat_swing_timer <= 0)
	{
		do_swing(_enemy);
		combat_swing_timer = combat_swing_period;
	}
}
else
{
	fighting = false;
	combat_swing_timer = 0;	// next encounter swings immediately on contact
	vel_x = move_speed * walk_dir;
}

// --- Sprite state machine -------------------------------------------------------
// Same as before: grounded → run, going up → jump, coming down → fall.
// (No dedicated combat sprite yet — he just looks like he's running in place
// while fighting, which reads as "swinging" well enough as a placeholder.)
if (grounded)
{
	if (sprite_index != spr_doozle_run)
	{
		sprite_index = spr_doozle_run;
		image_index = 0;
	}
}
else
{
	if (vel_y < 0)
	{
		if (sprite_index != spr_doozle_jump)
		{
			sprite_index = spr_doozle_jump;
			image_index = 0;
		}
	}
	else
	{
		if (sprite_index != spr_doozle_fall)
		{
			sprite_index = spr_doozle_fall;
			image_index = 0;
		}
	}
}
