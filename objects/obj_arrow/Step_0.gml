// Move.
x += vel_x;
y += vel_y;

// Hit detection is split by team. Knight arrows hit enemies; enemy arrows hit
// EITHER the player OR Sir Doozle — otherwise R archers would be a non-threat
// to a knight who closes in unscathed.
if (team == "knight")
{
	var _hit = instance_place(x, y, obj_enemy_parent);
	if (_hit != noone)
	{
		_hit.hp -= damage;

		// Per-enemy hit sound — falls back to generic Enemy_Death on unknown.
		var _hit_sound = snd_enemy_hit;
		switch (_hit.object_index)
		{
			case obj_enemy_r: _hit_sound = Archer_Damage;		break;
			case obj_enemy_y: _hit_sound = BadFairy_Damage;		break;
			case obj_enemy_b: _hit_sound = BlueMonster_Damage;	break;
		}
		audio_play_sound(_hit_sound, 0, 0);

		instance_destroy();
		exit;
	}
}
else
{
	// Enemy arrow vs Grizzelda — go through the hurt path (knockback + i-frames
	// + drop top item) instead of decrementing hp directly. Her template-style
	// 3-heart bar would otherwise overflow under arrow damage.
	var _player_hit = instance_place(x, y, obj_player);
	if (_player_hit != noone)
	{
		if (_player_hit.no_hurt_frames <= 0)
		{
			var _x_sign = sign(_player_hit.x - x);
			if (_x_sign == 0) _x_sign = 1;
			_player_hit.vel_x = _x_sign * 15;
			_player_hit.hp -= 1;
			_player_hit.in_knockback = true;
			_player_hit.no_hurt_frames = 120;
			_player_hit.sprite_index = spr_grizzelda_run_exhausted;
			_player_hit.image_index = 0;
			_player_hit.alarm[0] = 15;
			audio_play_sound(Damage, 0, 0);
			_player_hit.backpack_drop_top();
		}
		instance_destroy();
		exit;
	}

	// Enemy arrow vs Sir Doozle — straight hp drain on his 100 pool. No i-frame
	// system on him; if you're getting peppered with arrows, that's the game.
	// 6 dmg/arrow means a single archer takes ~17 shots to drop him from full,
	// giving Grizzelda generous time to deliver a sword/shield/potion.
	var _doozle_hit = instance_place(x, y, obj_sir_doozle);
	if (_doozle_hit != noone)
	{
		// Shield reflection: if Doozle has a wielded shield with charges
		// left, the arrow flips back at the original team (now friendly)
		// and a charge is consumed. The shield breaks at 0 charges — same
		// rule do_swing uses for melee blocks.
		var _has_shield = (_doozle_hit.equipped_item != undefined
						&& _doozle_hit.equipped_item.type == "shield"
						&& _doozle_hit.equipped_item.charges > 0);

		if (_has_shield)
		{
			team		= "knight";			// now hits enemies, not Grizzelda/Doozle
			vel_x		= -vel_x;
			vel_y		= -vel_y;
			image_angle	= (image_angle + 180) mod 360;
			image_xscale = (vel_x < 0) ? -1 : 1;

			// Empower the bounced arrow — enemies fire at heart-damage scale
			// (damage = 1), but a reflected arrow needs to do real work against
			// enemy hp pools. 25 matches Doozle's crossbow shot, enough to
			// one-shot a 20-hp R archer.
			damage		= max(damage, 25);

			_doozle_hit.equipped_item.charges -= 1;
			if (_doozle_hit.equipped_item.charges <= 0)
			{
				_doozle_hit.equipped_item = undefined;	// shield shatters
			}

			audio_play_sound(snd_enemy_hit, 0, 0);
			// Don't destroy — bounced arrow flies on. Next frame's move
			// step carries it out of Doozle's mask.
			exit;
		}

		_doozle_hit.hp -= 6;
		audio_play_sound(Damage_2, 0, 0);
		instance_destroy();
		exit;
	}
}

// Stuck in a wall? Stop and despawn after a beat.
if (place_meeting(x, y, obj_collision))
{
	instance_destroy();
	exit;
}

lifespan -= 1;
if (lifespan <= 0) instance_destroy();
