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

// Set true after consuming an item for a double-jump; reset on landing. Limits
// to one extra jump per air-time even if she has multiple items in her pack
// (so she can't ladder up indefinitely with a full backpack).
has_double_jumped = false;

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
drop_input			= false;

// --- World-item spawn (used by drop key and Doozle-swap) ------------------------
// Maps an inventory item struct's `type` field back to its world-object asset
// and instantiates one at (_x, _y). Stamps a half-second pickup grace so the
// dropping character can't immediately scoop it back up.
spawn_world_item = function(_item_struct, _x, _y)
{
	var _obj = noone;
	switch (_item_struct.type)
	{
		case "sword":		_obj = obj_item_sword;		break;
		case "shield":		_obj = obj_item_shield;		break;
		case "crossbow":	_obj = obj_item_crossbow;	break;
		case "jumpfruit":	_obj = obj_item_jumpfruit;	break;
		case "potion":		_obj = obj_item_potion;		break;
		case "wood":		_obj = obj_item_wood;		break;
	}

	if (_obj != noone)
	{
		var _spawned = instance_create_layer(_x, _y, "Instances", _obj);
		_spawned.no_pickup_frames = 30;	// ~0.5s at 60fps
		return _spawned;
	}
	return noone;
};

// --- Action functions -----------------------------------------------------------
player_jump = function()
{
	if (!grounded)
	{
		// Airborne — try the double-jump-by-item-consumption mechanic.
		// One extra jump per air-time, requires an equipped item, item is
		// destroyed (no world drop — it's "spent" as fuel). Full jump impulse
		// regardless of weight tier, since the item is the energy source.
		if (!has_double_jumped && equipped_index >= 0)
		{
			var _consumed = backpack_take_equipped();
			if (_consumed != undefined)
			{
				vel_y = -jump_speed;

				sprite_index = spr_grizzelda_jump;
				image_index = 0;

				instance_create_layer(x, bbox_bottom, "Instances", obj_effect_jump);

				audio_play_sound(Jump2, 0, 0);

				has_double_jumped = true;
			}
		}
		jump_input = false;
		return;
	}

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

	audio_play_sound(Jump, 0, 0);

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

// G — drop the currently equipped item back into the world. Does nothing if
// the backpack is empty. The dropped instance gets a 0.5s pickup grace so she
// doesn't re-collect it on the same frame she dropped it.
player_drop = function()
{
	if (equipped_index < 0) { drop_input = false; return; }

	var _item = backpack_take_equipped();
	if (_item == undefined) { drop_input = false; return; }

	spawn_world_item(_item, x, y);
	audio_play_sound(Get_Item_3, 0, 0);

	drop_input = false;
};

// F use action. Branches by equipped item type:
//   wood  → place a bridge in front of Grizzelda (consumes the item).
//   else  → hand-off to Sir Doozle when in range.
//
// Wood is the squire's gap-filler: she can drop a plank for Doozle to walk
// across, but only when she's standing on solid ground herself (so you can't
// stair-step planks midair to skip terrain).
player_use = function()
{
	if (equipped_index < 0) { use_input = false; return; }

	var _equipped = backpack[equipped_index];

	if (_equipped.type == "wood")
	{
		// ============================================================
		// WOOD PLACEMENT TWEAK ZONE — adjust 1px at a time, hold F1 in
		// game to see bboxes (green = player, red = collision).
		// ============================================================
		// Marker-based bridge segments (obj_bridge_segment):
		var _bridge_outer_y_nudge  = 0;     // first + last segments collision Y
		var _bridge_middle_y_nudge = -1;    // middle segments collision Y
		// Free-form planks (obj_wood_placed) — vertical clearance from her feet:
		var _plank_y_clearance     = 2;     // 0 = touching (blocks); 1-3 = clearance
		// ============================================================

		// --- Bridge mode: fill if a connection marker is nearby --------------
		// Level designers place obj_legal_plank_connection markers in pairs to
		// define legal bridge spans. If Grizzelda is near a marker, we spawn
		// obj_bridge_segment instances between the marker and its sibling.
		// Free-form placement below is the fallback.
		//
		// Grounded check: bridge geometry depends on her standing y, and she
		// shouldn't be stair-stepping bridges in midair anyway.
		if (!grounded) { use_input = false; return; }

		var _connector = noone;
		var _connector_range = 150;
		with (obj_legal_plank_connection)
		{
			var _d = point_distance(x, y, other.x, other.y);
			if (_d > _connector_range) continue;
			if (_connector == noone
				|| _d < point_distance(_connector.x, _connector.y, other.x, other.y))
			{
				_connector = id;
			}
		}

		if (_connector != noone)
		{
			// Find the closest sibling marker at the same Y row (±16px).
			var _sibling = noone;
			with (obj_legal_plank_connection)
			{
				if (id == _connector) continue;
				if (abs(y - _connector.y) > 16) continue;
				if (_sibling == noone
					|| abs(x - _connector.x) < abs(_sibling.x - _connector.x))
				{
					_sibling = id;
				}
			}

			if (_sibling != noone)
			{
				// Spawn obj_bridge_segment instances (wood-plank visual via
				// spr_block_coins_inactive, walkable via obj_collision parent)
				// at sprite-width steps across the gap.
				//
				// Per-segment Y nudges come from the WOOD PLACEMENT TWEAK ZONE
				// at the top of player_use. Edit there, not here.
				var _outer_y_nudge	= _bridge_outer_y_nudge;
				var _middle_y_nudge	= _bridge_middle_y_nudge;

				var _seg_w		= sprite_get_width(spr_block_coins_inactive);
				var _y_pix		= _connector.y;
				var _x_left		= min(_connector.x, _sibling.x);
				var _x_right	= max(_connector.x, _sibling.x);

				// Pre-compute segment count so we know which is "last".
				var _seg_count = floor((_x_right - _x_left) / _seg_w) + 1;
				var _seg_idx = 0;

				var _sx = _x_left;
				while (_sx <= _x_right)
				{
					var _is_outer	= (_seg_idx == 0) || (_seg_idx == _seg_count - 1);
					var _spawn_y	= _y_pix + (_is_outer ? _outer_y_nudge : _middle_y_nudge);

					instance_create_layer(_sx, _spawn_y, "Instances", obj_bridge_segment);

					_sx += _seg_w;
					_seg_idx += 1;
				}

				// Bridge built — markers have done their job, remove them so
				// they don't sit visible on the bridge or trigger again.
				instance_destroy(_connector);
				instance_destroy(_sibling);

				backpack_take_equipped();
				audio_play_sound(Get_Item_3, 0, 0);
				use_input = false;
				return;
			}
		}

		// --- Free-form placement (fallback) -----------------------------------
		// Place the plank past her bbox horizontally and just below her feet
		// vertically. We read the placed-wood sprite's bbox at runtime so
		// future art changes don't re-trap her — the math always lines up
		// with whatever bbox the current sprite has.
		var _facing = (image_xscale != 0) ? sign(image_xscale) : 1;

		var _spr			= spr_wood_placed;
		var _origin_x		= sprite_get_xoffset(_spr);
		var _origin_y		= sprite_get_yoffset(_spr);
		var _plank_left_ext	= _origin_x - sprite_get_bbox_left(_spr);		// extent left of origin
		var _plank_right_ext= sprite_get_bbox_right(_spr) - _origin_x;		// extent right of origin
		var _plank_top_ext	= _origin_y - sprite_get_bbox_top(_spr);		// extent above origin

		// Plank's near edge sits 2px beyond her bbox in the facing direction.
		var _player_edge	= (_facing > 0) ? bbox_right : bbox_left;
		var _near_ext		= (_facing > 0) ? _plank_left_ext : _plank_right_ext;
		var _px				= _player_edge + _facing * (_near_ext + 2);

		// Plank's collision top offset below her feet by _plank_y_clearance
		// (from the tweak zone at the top of player_use). 0 = touching (will
		// trap her); 1-3 typical; bump higher if she catches on the seam.
		var _py				= bbox_bottom + _plank_top_ext + _plank_y_clearance;

		// Don't place inside terrain — quick guard against burying the plank.
		if (!position_meeting(_px, _py, obj_collision))
		{
			instance_create_layer(_px, _py, "Instances", obj_wood_placed);
			backpack_take_equipped();		// consume the wood
			audio_play_sound(Get_Item_3, 0, 0);
		}

		use_input = false;
		return;
	}

	// Default: hand the equipped item to Sir Doozle if he's nearby.
	var _doozle = instance_nearest(x, y, obj_sir_doozle);
	if (_doozle == noone) { use_input = false; return; }

	if (point_distance(x, y, _doozle.x, _doozle.y) > 80)
	{
		use_input = false;
		return;
	}

	var _item = backpack_take_equipped();
	if (_item == undefined) { use_input = false; return; }

	// Potions don't equip — they heal Doozle on handoff and get consumed.
	// 50hp = half his pool, so a single potion is a meaningful save but two
	// don't make him invincible. Pre-existing healing audio for the cue.
	if (_item.type == "potion")
	{
		_doozle.hp = min(_doozle.max_hp, _doozle.hp + 50);
		audio_play_sound(Heal, 0, 0);
		use_input = false;
		return;
	}

	// Swap: if Doozle is already wielding something, drop the old item at his
	// position so it isn't silently destroyed. Grizzelda can re-pick it later.
	if (_doozle.equipped_item != undefined)
	{
		spawn_world_item(_doozle.equipped_item, _doozle.x, _doozle.y);
	}

	_doozle.equipped_item = _item;
	_doozle.doozle_init_equipped();		// stamps per-type combat stats onto the struct

	audio_play_sound(Get_Item_2, 0, 0);

	use_input = false;
};
