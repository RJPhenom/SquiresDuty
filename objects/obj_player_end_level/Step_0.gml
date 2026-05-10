// Run the parent's Step event (gravity, friction, pixel-perfect movement).
event_inherited();

// target_gate is set by the spawning collision event (obj_player's gate
// collision passes other.id). Without that, fall back to the first end_gate
// instance — but rooms with multiple gates only behave right when target_gate
// is set explicitly.
if (!variable_instance_exists(id, "target_gate") || target_gate == noone)
{
	target_gate = (instance_exists(obj_end_gate)) ? instance_find(obj_end_gate, 0) : noone;
}

if (target_gate == noone || !instance_exists(target_gate))
{
	// Gate destroyed mid-fade or never set. Skip to the room change so we
	// don't softlock with a partially faded Grizzelda.
	room_goto_next();
	exit;
}

if (x != target_gate.x)
{
	// Walking phase — toward the SPECIFIC gate she hit, slower than her
	// gameplay run.
	vel_x = sign(target_gate.x - x) * 4;
	sprite_index = spr_grizzelda_run;
	image_speed = 0.7;

	if (abs(target_gate.x - x) < 5)
	{
		x = target_gate.x;
		vel_x = 0;
	}
}
else
{
	// Standing-at-gate phase — fade out.
	sprite_index = spr_grizzelda_idle;
	image_alpha += -0.02;
	image_speed = 1;

	if (image_alpha <= 0)
	{
		room_goto_next();
	}
}
