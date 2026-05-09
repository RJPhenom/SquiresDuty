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
		audio_play_sound(snd_enemy_hit, 0, 0);
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
			audio_play_sound(snd_life_lost_01, 0, 0);
			_player_hit.backpack_drop_top();
		}
		instance_destroy();
		exit;
	}

	// Enemy arrow vs Sir Doozle — straight hp drain on his 100 pool. No i-frame
	// system on him; if you're getting peppered with arrows, that's the game.
	// 10 dmg/arrow is light enough that a single archer takes ~10 shots to drop
	// him, giving Grizzelda time to deliver a sword.
	var _doozle_hit = instance_place(x, y, obj_sir_doozle);
	if (_doozle_hit != noone)
	{
		_doozle_hit.hp -= 10;
		audio_play_sound(snd_life_lost_01, 0, 0);
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
