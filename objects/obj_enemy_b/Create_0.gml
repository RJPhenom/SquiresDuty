event_inherited();

// "B" — dumb monster, swings his arms, damages on collision. Walks left/right
// like obj_enemy1 with the standard wall/ledge turn behavior from
// obj_enemy_parent.End Step. Killable by sword OR crossbow per GDD.
defeated_object = obj_enemy_defeated;

move_speed	= 2;
vel_x		= choose(-move_speed, move_speed);

// 30 HP — same as the existing enemy1; sword (10/swing) kills in 3, crossbow
// (25/arrow) kills in 2.
max_hp	= 30;
hp		= max_hp;

// Touch damage to Grizzelda (1 heart). Doozle's combat code uses a separate
// hardcoded 15 dmg/atk against him, see do_swing.
damage = 1;
