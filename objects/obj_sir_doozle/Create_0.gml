// Inherit obj_character_parent (vel_x/y, gravity, friction, hp scaffolding).
event_inherited();

// Sir Doozle walks on his own. Per GDD he moves at ~⅓ Grizzelda's pace; her
// move_speed is 8, so 3 keeps him visibly slower without being a snail.
move_speed	= 3;
walk_dir	= 1;
vel_x = move_speed * walk_dir;

// HP per GDD ("100 invisible health"). Visible bar comes from obj_hud_doozle_hp.
max_hp	= 100;
hp		= max_hp;

// --- Combat state ---------------------------------------------------------------
// equipped_item: struct received from Grizzelda — { type, sprite, height, [stats] }
// where [stats] is per-type: sword.durability, shield.charges, crossbow.ammo.
equipped_item			= undefined;

// `fighting` is set true while there's an enemy directly in front of him. While
// fighting he stops moving (Step_2 zeroes vel_x) and ticks a swing timer.
fighting				= false;

// Frames until the next swing while engaged. Reset to combat_swing_period on
// every connecting hit. Period of 60 = 1 swing per second → matches GDD's
// "After 3-5 seconds Sir Doozle wins" with a sword (3 swings × 1s = 3s).
combat_swing_timer		= 0;
combat_swing_period		= 60;

// --- Item handoff: initialize per-type combat stats when an item arrives -------
// Called from obj_player.player_use after assigning equipped_item. Putting the
// init here (rather than on the player) keeps weapon-specific knowledge with
// the thing that wields the weapon.
doozle_init_equipped = function()
{
	if (equipped_item == undefined) return;
	switch (equipped_item.type)
	{
		case "sword":		equipped_item.durability	= 90;	break;
		case "shield":		equipped_item.charges		= 3;	break;
		case "crossbow":	equipped_item.ammo			= 3;	break;
		// jumpfruit / coin / anything else: no combat stats — held but inert.
	}
};

// --- Swing resolution ----------------------------------------------------------
// Called from Step_2 when combat_swing_timer hits 0. _enemy is the obj_enemy
// instance he's actively fighting. Applies damage in both directions based on
// the equipped weapon and consumes weapon durability/charges. Sets equipped_item
// = undefined when a weapon breaks.
do_swing = function(_enemy)
{
	// Default melee damage TO Sir Doozle from a melee enemy (GDD: melee = 15 dmg/atk).
	// We hardcode this here rather than reading _enemy.damage so the small value used
	// for Grizzelda's 3-heart bar (1) doesn't underflow against his 100hp pool.
	var _melee_dmg_to_me = 15;

	var _dmg_to_enemy	= 0;
	var _dmg_to_me		= _melee_dmg_to_me;

	if (equipped_item == undefined)
	{
		// Bare fists: GDD says 5 dmg to enemies, takes the full melee hit back.
		_dmg_to_enemy = 5;
	}
	else
	{
		switch (equipped_item.type)
		{
			case "sword":
				// 10 dmg/swing. Enemy melee is fully blocked while sword is up
				// (GDD: "reduced to 0 or 5"). Sword loses 10 durability per hit.
				_dmg_to_enemy = 10;
				_dmg_to_me = 0;
				equipped_item.durability -= 10;
				if (equipped_item.durability <= 0)
				{
					equipped_item = undefined;	// snapped — fists from here on
				}
				break;

			case "shield":
				// Shield doesn't kill, but it eats melee hits — GDD framing is
				// arrow reflection but it's the closest analog for melee. 3 hits
				// before it shatters.
				_dmg_to_enemy	= 0;
				_dmg_to_me		= 0;
				equipped_item.charges -= 1;
				if (equipped_item.charges <= 0)
				{
					equipped_item = undefined;
				}
				break;

			case "crossbow":
				// Per GDD the crossbow only fires at flying enemies (which don't
				// exist yet). At melee range it's effectively useless — he ends
				// up swinging it like a club for fist damage and takes full hits.
				// TODO: when obj_enemy_flying exists, separate AI handles ranged
				// firing (auto-track arrow projectile, 25 dmg, ammo--).
				_dmg_to_enemy = 5;
				break;

			case "jumpfruit":
				// GDD: jumpfruit only enables Grizzelda's multi-jump. Useless to
				// the knight — fist-equivalent damage in/out.
				_dmg_to_enemy = 5;
				break;

			default:
				_dmg_to_enemy = 5;
				break;
		}
	}

	_enemy.hp	-= _dmg_to_enemy;
	hp			-= _dmg_to_me;

	audio_play_sound(snd_enemy_hit, 0, 0);
};
