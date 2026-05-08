// Inherit obj_character_parent: vel_x/y, gravity, friction, hp, grounded, etc.
event_inherited();

// --- Knockback / defeat (existing template behavior, preserved) ----------------
in_knockback	= false;
defeated_object	= obj_player_defeated;

// Vestigial: the template's coin HUD (obj_hud_coins) reads obj_player.coins
// every frame. Coins are now generic backpack items, but the HUD is still in
// the seq_game_hud sequence — declare the variable so the HUD draws 0
// instead of crashing. Remove this line once obj_hud_coins is unhooked from
// the HUD sequence.
coins = 0;

// --- Backpack inventory ---------------------------------------------------------
// Stack of item structs; index 0 = bottom, last index = top of pile.
// Each entry: { type: string, label: string, color: color, height: pixels }
backpack		= [];

// Index of the currently equipped item (the one outlined in red). -1 = nothing.
equipped_index	= -1;

// Tilt of the stack (degrees). Lerps toward target_tilt each frame so heavy lean
// trails the actual movement, like a Death Stranding pile shifting from inertia.
stack_tilt		= 0;
target_tilt		= 0;

// --- Weight tiers (drives both movement scaling AND sprite/jump state) ----------
// 0 = light	(0–3 items)		— full speed, full jump, base run sprite
// 1 = tired	(4–7 items)		— 75% speed, 60% jump, tired run sprite
// 2 = exhausted (8+ items)		— 55% speed, no jump, exhausted run sprite
get_weight_tier = function()
{
	var _n = array_length(backpack);
	if (_n >= 8) return 2;
	if (_n >= 4) return 1;
	return 0;
};

get_weight_factor = function()
{
	switch (get_weight_tier())
	{
		case 2: return 0.55;
		case 1: return 0.75;
		default: return 1.00;
	}
};

get_jump_factor = function()
{
	switch (get_weight_tier())
	{
		case 2: return 0.0;		// exhausted: literally cannot jump
		case 1: return 0.6;		// tired: stunted hop
		default: return 1.0;
	}
};

get_run_sprite = function()
{
	switch (get_weight_tier())
	{
		case 2: return spr_grizzelda_run_exhausted;
		case 1: return spr_grizzelda_run_tired;
		default: return spr_grizzelda_run;
	}
};

// --- Inventory helpers ----------------------------------------------------------
// Adds an item struct to the top of the pile and equips it.
// Each entry stores everything Draw_0 needs to render it on the stack:
//   sprite — the world sprite asset (drawn rotated with the stack tilt)
//   height — how tall the slot is in pixels (drives stack height + tilt feel)
backpack_push = function(_item_type, _sprite, _height)
{
	array_push(backpack, {
		type:	_item_type,
		sprite:	_sprite,
		height:	_height,
	});
	equipped_index = array_length(backpack) - 1;
};

// Removes the equipped item, returns its struct (or undefined).
backpack_take_equipped = function()
{
	if (equipped_index < 0 || equipped_index >= array_length(backpack)) return undefined;
	var _item = backpack[equipped_index];
	array_delete(backpack, equipped_index, 1);
	equipped_index = array_length(backpack) - 1;
	return _item;
};

// Cycles the equipped index in `_dir` (1 = next, -1 = previous). Wraps around.
backpack_cycle = function(_dir)
{
	var _n = array_length(backpack);
	if (_n == 0) { equipped_index = -1; return; }
	equipped_index = (equipped_index + _dir + _n) mod _n;
};

// Knocks the top item off (called when Grizzelda is hit by an enemy).
backpack_drop_top = function()
{
	var _n = array_length(backpack);
	if (_n == 0) return;
	array_delete(backpack, _n - 1, 1);
	equipped_index = array_length(backpack) - 1;
	// (GDD says items "get dropped and destroyed" on hit — physics-toss is a polish pass.)
};

// --- Input flag bag -------------------------------------------------------------
// Each Keyboard / KeyPress event sets a flag here; Step_1 reads them and dispatches.
jump_input			= false;
left_input			= false;
right_input			= false;
cycle_next_input	= false;
cycle_prev_input	= false;
use_input			= false;

// --- Action functions -----------------------------------------------------------
player_jump = function()
{
	if (!grounded) { jump_input = false; return; }

	var _factor = get_jump_factor();
	if (_factor <= 0)
	{
		// Exhausted — too laden to leave the ground. Flag is consumed; no jump occurs.
		// (Audio/VFX cue for the failed jump can come later.)
		jump_input = false;
		return;
	}

	vel_y = -jump_speed * _factor;

	sprite_index = spr_grizzelda_jump;
	image_index = 0;

	grounded = false;

	instance_create_layer(x, bbox_bottom, "Instances", obj_effect_jump);

	var _sound = audio_play_sound(snd_jump, 0, 0);
	audio_sound_pitch(_sound, random_range(0.8, 1));

	jump_input = false;
};

player_left = function()
{
	if (in_knockback) return;

	vel_x = -move_speed * get_weight_factor();

	if (sprite_index == spr_grizzelda_fall) return;
	if (grounded) sprite_index = get_run_sprite();

	left_input = false;
};

player_right = function()
{
	if (in_knockback) return;

	vel_x = move_speed * get_weight_factor();

	if (sprite_index == spr_grizzelda_fall) return;
	if (grounded) sprite_index = get_run_sprite();

	right_input = false;
};

// F (or wherever else "use" is bound). Phase 1 use = hand-off to Sir Doozle when in range.
player_use = function()
{
	if (equipped_index < 0) { use_input = false; return; }

	var _doozle = instance_nearest(x, y, obj_sir_doozle);
	if (_doozle == noone) { use_input = false; return; }

	if (point_distance(x, y, _doozle.x, _doozle.y) > 80)
	{
		use_input = false;
		return;
	}

	var _item = backpack_take_equipped();
	if (_item == undefined) { use_input = false; return; }

	_doozle.equipped_item = _item;
	_doozle.doozle_init_equipped();		// stamps per-type combat stats onto the struct

	audio_play_sound(snd_box_get, 0, 0);

	use_input = false;
};
