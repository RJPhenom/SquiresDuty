// Doozle's "teleport into the gate" sequence — mirror of obj_player_end_level.
// Walks him to the SPECIFIC gate he hit, fades him to transparent, then sets
// the global flag that lets Grizzelda enter (so she's gated on his FULL fade,
// not just on his initial gate touch). Self-destroys when fade completes.
event_inherited();

// target_gate is set by the spawning collision event (Sir Doozle's gate
// collision passes other.id). Without that, fall back to the first end_gate
// instance — but rooms with multiple gates only behave right when target_gate
// is set explicitly.
if (!variable_instance_exists(id, "target_gate") || target_gate == noone)
{
	target_gate = (instance_exists(obj_end_gate)) ? instance_find(obj_end_gate, 0) : noone;
}

if (target_gate == noone || !instance_exists(target_gate))
{
	// Gate destroyed mid-fade or never set. Bail cleanly.
	instance_destroy();
	exit;
}

if (x != target_gate.x)
{
	// Walking phase: amble toward THIS gate's center at half-pace, run anim playing.
	vel_x = sign(target_gate.x - x) * 4;
	sprite_index = spr_doozle_run;
	image_speed = 0.7;

	if (abs(target_gate.x - x) < 5)
	{
		// Snap to center and stop.
		x = target_gate.x;
		vel_x = 0;
	}
}
else
{
	// Standing-at-gate phase: fade out. No idle sprite for Doozle, so we
	// freeze the run animation by zeroing image_speed.
	vel_x = 0;
	image_speed = 0;
	image_alpha -= 0.02;

	if (image_alpha <= 0)
	{
		// Fully teleported — NOW unlock Grizzelda's gate.
		global.doozle_reached_end = true;
		instance_destroy();
	}
}
