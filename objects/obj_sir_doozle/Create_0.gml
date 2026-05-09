// Inherit obj_character_parent (vel_x/y, gravity, friction, hp scaffolding).
event_inherited();

// Override the inherited default (which is obj_player_defeated — Grizzelda's
// death anim). When Doozle's hp hits 0, character_parent.End Step swaps in
// THIS object instead, which plays his own death-flop and restarts the room.
defeated_object = obj_doozle_defeated;

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

// --- Combat detection knobs ----------------------------------------------------
// With a melee weapon, only the closest 6px ahead matter. With a crossbow he's
// a sniper — he stops to fire at any threat in this radius, including fliers.
melee_check_dist	= 6;
ranged_check_radius	= 320;

// --- Swing resolution ----------------------------------------------------------
// Called from Step_2 when combat_swing_timer hits 0. _enemy is the threat he's
// engaging — close-melee target for sword/shield/fists, line-of-sight target
// for the crossbow.
//
// Applies damage in both directions based on the equipped weapon and consumes
// weapon durability/charges/ammo. Sets equipped_item = undefined when a weapon
// breaks/empties.
do_swing = function(_enemy)
{
	// Default melee damage TO Sir Doozle from a melee enemy (GDD: melee = 15 dmg/atk).
	// We hardcode this here rather than reading _enemy.damage so the small value used
	// for Grizzelda's 3-heart bar (1) doesn't underflow against his 100hp pool.
	// Fliers can't melee him back — they only collide-damage Grizzelda — so when
	// the target is_flying we zero this out below.
	var _melee_dmg_to_me = _enemy.is_flying ? 0 : 15;

	var _dmg_to_enemy	= 0;
	var _dmg_to_me		= _melee_dmg_to_me;
	var _is_ranged		= false;

	if (equipped_item == undefined)
	{
		// Bare fists: 5 dmg to grounded enemies, can't reach a flier.
		_dmg_to_enemy = _enemy.is_flying ? 0 : 5;
	}
	else
	{
		switch (equipped_item.type)
		{
			case "sword":
				// 10 dmg/swing on grounded enemies; can't reach fliers (GDD).
				// Sword fully blocks melee return damage. -10 durability per
				// connecting hit; on a missed swing (flier) durability stays.
				if (_enemy.is_flying)
				{
					_dmg_to_enemy	= 0;
					_dmg_to_me		= 0;
				}
				else
				{
					_dmg_to_enemy = 10;
					_dmg_to_me = 0;
					equipped_item.durability -= 10;
					if (equipped_item.durability <= 0)
					{
						equipped_item = undefined;	// snapped — fists from here on
					}
				}
				break;

			case "shield":
				// Shield doesn't kill, but it eats melee hits — GDD framing is
				// arrow reflection but it's the closest analog for melee. 3 hits
				// before it shatters. Useless against fliers (no contact, no
				// charge consumed).
				_dmg_to_enemy	= 0;
				_dmg_to_me		= 0;
				if (!_enemy.is_flying)
				{
					equipped_item.charges -= 1;
					if (equipped_item.charges <= 0)
					{
						equipped_item = undefined;
					}
				}
				break;

			case "crossbow":
				// Spawn an arrow toward the target instead of dealing damage
				// directly. Arrow handles its own collision + damage on impact.
				// 25 dmg / arrow per GDD; ammo-- per shot, breaks at 0.
				_is_ranged = true;
				_dmg_to_me = 0;	// firing position is safe; melee return fires
								// only if the enemy is touching him AND he chose
								// to shoot anyway. Acceptable simplification.

				var _ax = x;
				var _ay = y - 24;
				var _dir = point_direction(_ax, _ay, _enemy.x, _enemy.y - 24);

				var _arrow = instance_create_layer(_ax, _ay, "Instances", obj_arrow);
				_arrow.team			= "knight";
				_arrow.damage		= 25;
				_arrow.vel_x		= lengthdir_x(14, _dir);
				_arrow.vel_y		= lengthdir_y(14, _dir);
				_arrow.image_angle	= _dir;
				_arrow.image_xscale	= sign(_arrow.vel_x);
				if (_arrow.image_xscale == 0) _arrow.image_xscale = 1;

				equipped_item.ammo -= 1;
				if (equipped_item.ammo <= 0)
				{
					equipped_item = undefined;	// out of arrows
				}
				break;

			case "jumpfruit":
				// GDD: jumpfruit only enables Grizzelda's multi-jump. Useless to
				// the knight — fist-equivalent damage in/out, can't reach fliers.
				_dmg_to_enemy = _enemy.is_flying ? 0 : 5;
				break;

			default:
				_dmg_to_enemy = _enemy.is_flying ? 0 : 5;
				break;
		}
	}

	// Ranged path applies damage via the arrow on impact, not here.
	if (!_is_ranged)
	{
		_enemy.hp -= _dmg_to_enemy;
	}
	hp -= _dmg_to_me;

	audio_play_sound(snd_enemy_hit, 0, 0);
};
