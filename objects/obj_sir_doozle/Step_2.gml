// Run the parent End Step (sprite flipping, defeat handling, invincibility flashing).
event_inherited();

// --- Combat detection: is there an enemy directly in front of him? --------------
// Look 6px ahead at body height. If something's there, stop and fight; otherwise
// keep marching. Using instance_place (rather than overlap with self) so combat
// triggers on contact, not after they've intersected.
var _enemy = noone;
if (walk_dir != 0)
{
	_enemy = instance_place(x + walk_dir * 6, y, obj_enemy_parent);
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
