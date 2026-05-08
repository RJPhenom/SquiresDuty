// Inherit parent End Step (sprite flipping, defeat handling, invincibility flashing).
event_inherited();

// --- Backpack tilt --------------------------------------------------------------
// Lean opposite to motion when accelerating, then settle. Heavier stacks lean more.
var _stack_n = array_length(backpack);
var _max_lean = 6 + min(_stack_n, 8) * 2;	// 6° empty, ramping up with weight
target_tilt = -clamp(vel_x * 1.4, -_max_lean, _max_lean);
stack_tilt = lerp(stack_tilt, target_tilt, 0.18);

// --- Sprite state machine -------------------------------------------------------
// Running sprites collapse: while grounded and moving, the run sprite is picked by
// weight tier (light/tired/exhausted). Off the ground we use jump/fall.
var _is_run_sprite =
	sprite_index == spr_grizzelda_run			||
	sprite_index == spr_grizzelda_run_tired		||
	sprite_index == spr_grizzelda_run_exhausted;

if (_is_run_sprite)
{
	image_speed = 1;

	if (grounded)
	{
		// Re-pick the run sprite each frame so picking up an item mid-stride
		// transitions cleanly into the tired/exhausted variant.
		var _want = get_run_sprite();
		if (sprite_index != _want)
		{
			sprite_index = _want;
		}
		if (vel_x == 0) sprite_index = spr_grizzelda_idle;
	}
	if (vel_y > 1)
	{
		sprite_index = spr_grizzelda_fall;
		image_index = 0;
	}
}
else
{
	switch (sprite_index)
	{
		case spr_grizzelda_jump:
			if (vel_y >= 0)
			{
				sprite_index = spr_grizzelda_fall;
				image_index = 0;
				image_speed = 1;
			}
			break;

		case spr_grizzelda_fall:
			if (grounded)
			{
				sprite_index = spr_grizzelda_idle;
				image_speed = 1;
				audio_play_sound(snd_land_01, 0, 0);
			}
			break;

		case spr_grizzelda_run_exhausted:	// reused as "hurt" pose — see Collision_obj_enemy_parent
			if (grounded)
			{
				var _dust = instance_create_layer(x, bbox_bottom, layer, obj_effect_knockback);
				_dust.image_xscale = image_xscale;
			}
			break;

		default:
			image_speed = 1;
			break;
	}
}
