event_inherited();

// This is the object that replaces the enemy once it is defeated.
defeated_object = obj_enemy1_defeated;

// This sets the movement speed for this particular enemy.
move_speed = 2;

// Either move_speed or negative move_speed → enemy walks left or right.
vel_x = choose(-move_speed, -move_speed);

// --- GDD: Melee enemy stats ----------------------------------------------------
// 30 HP — Sir Doozle's sword does 10 dmg per swing, so a sword-equipped knight
// kills this in 3 swings (matches GDD's "3 hits with sword").
max_hp	= 30;
hp		= max_hp;

// `damage` is the per-frame knockback hit applied to Grizzelda when she touches
// the enemy. The template ramps her hp down by this much per collision tick.
// Doozle's combat code ignores this and uses the GDD melee figure (15) directly,
// so we keep this small to avoid one-shotting Grizzelda's 3-heart bar.
damage = 1;
