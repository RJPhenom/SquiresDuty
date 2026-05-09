event_inherited();

// "Y" — flier. Drifts back and forth at altitude. Per GDD, melee weapons can't
// reach a flier; he is ONLY damageable by Doozle's crossbow arrows. We surface
// that to the rest of the codebase via is_flying = true; do_swing on Sir Doozle
// uses this flag to short-circuit melee damage.
defeated_object = obj_enemy_defeated;
is_flying = true;

// Hovers in place — only the vertical bob in Step_1 moves him. If you want
// patrolling fliers later, restore move_speed and vel_x = choose(±move_speed)
// and the wall-flip in Step_2 will handle bouncing him off geometry.
move_speed	= 0;
vel_x		= 0;
vel_y		= 0;

max_hp	= 30;
hp		= max_hp;

// Touch damage to Grizzelda — fliers harass her if she's underneath. 1 heart
// like the others.
damage = 1;

// Vertical bob — a little sine wave around the spawn altitude makes him feel
// alive without needing pathfinding.
bob_t			= random(360);
bob_amplitude	= 6;
spawn_x			= x;
spawn_y			= y;

// --- Dive state machine ---------------------------------------------------------
//   "hover"  — bob in place at spawn position
//   "dive"   — descend toward Doozle's position at dive_speed
//   "return" — climb back to spawn at return_speed (smooth, not teleport)
state			= "hover";

// Trigger geometry: Doozle must be within this many px horizontally AND below
// us by at least dive_min_dy (so we don't dive sideways at someone level with
// us). dive_max_dy caps how far down we'll chase before giving up.
dive_trigger_x	= 300;
dive_min_dy		= 50;
dive_max_dy		= 800;

dive_speed		= 9;
return_speed	= 4;
dive_damage		= 20;	// per hit; consumed once then we go to return state
