event_inherited();

// "Y" — flier. Drifts back and forth at altitude. Per GDD, melee weapons can't
// reach a flier; he is ONLY damageable by Doozle's crossbow arrows. We surface
// that to the rest of the codebase via is_flying = true; do_swing on Sir Doozle
// uses this flag to short-circuit melee damage.
defeated_object = obj_enemy_defeated;
is_flying = true;

move_speed	= 2.5;
vel_x		= choose(-move_speed, move_speed);
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
spawn_y			= y;
