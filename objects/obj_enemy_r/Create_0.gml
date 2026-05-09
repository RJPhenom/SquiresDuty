event_inherited();

// "R" — stationary archer. Stands his ground and shoots arrows when an
// in-range target lines up at roughly his height. Killable by sword or
// crossbow per GDD.
defeated_object = obj_enemy_defeated;

// Hold position. The parent enemy step code that turns at walls/ledges still
// runs but with vel_x = 0 it has nothing to flip; fine.
move_speed	= 0;
vel_x		= 0;

max_hp	= 30;
hp		= max_hp;

// Contact damage if you walk into him is the same template-shared 1 heart;
// the real threat is the arrows.
damage = 1;

// --- Ranged attack ----------------------------------------------------------
fire_cooldown	= 0;
fire_period		= 90;	// ~1.5 seconds between shots at 60fps
fire_range		= 600;	// horizontal sight range in pixels
fire_y_band		= 80;	// must be within this many px of his height to fire
arrow_speed		= 12;	// projectile pixels/frame; obj_arrow handles travel
