// Stomp check: if she's falling onto the enemy from above, BOUNCE off without
// damage to either side. Combat is Sir Doozle's job — Grizzelda's relationship
// with enemies is purely platforming (you can use them as bouncepads, like
// SMB Spinies you can ride on). Damage to her still happens via the default
// path below if she's NOT coming down on the enemy.
if (vel_y > 0)
{
	// Was her bbox bottom above the enemy's last frame? Then this frame's
	// overlap is from above — qualifies as a stomp.
	if ((bbox_bottom - vel_y) < (other.bbox_bottom - other.vel_y))
	{
		vel_y = -jump_speed;

		sprite_index = spr_grizzelda_jump;
		image_index = 0;
		image_speed = 1;

		instance_create_layer(x, bbox_bottom, "Instances", obj_effect_jump);

		audio_play_sound(Jump, 0, 0);

		// Brief i-frames so a low-clearance bounce doesn't immediately re-collide
		// and apply contact damage on the same enemy.
		no_hurt_frames = max(no_hurt_frames, 30);

		exit;
	}
}

// This checks if the player is invincible, by checking if no_hurt_frames is greater than 0.
if (no_hurt_frames > 0)
{
	// In that case we exit the event so the player is not hurt by the enemy.
	exit;
}

// This section hurts the player, because it only runs if the player was not found to be jumping on the enemy's head.
// This action gets the sign (1, 0 or -1) from the enemy's position to the player's position.
var _x_sign = sign(x - other.x);

// That sign is multiplied by 15, and applied to vel_x as the knockback.
vel_x = _x_sign * 15;

// This first reduces the player's health by the damage amount in the 'other' instance
// (which is the enemy).
// Then it sets 'in_knockback' to true to tell the player that it's in knockback.
hp -= other.damage;
in_knockback = true;

// This sets no_hurt_frames to 120, so the player is invincible for the next 2 seconds (as one second contains 60 frames).
no_hurt_frames = 120;

// This changes the sprite to the hurt sprite.
// No dedicated grizzelda_hurt sprite — reuse the exhausted-run pose for the
// knockback flash. Reads as "she's wobbling from the hit" well enough.
sprite_index = spr_grizzelda_run_exhausted;
image_index = 0;

// Set Alarm 0 to run after 15 frames; that event stops the player's horizontal velocity, ending the knockback
alarm[0] = 15;

// Play the 'life lost' sound effect
audio_play_sound(Damage, 0, 0);

// Knock the top item off Grizzelda's backpack (GDD: items can be dropped/destroyed on hit).
backpack_drop_top();