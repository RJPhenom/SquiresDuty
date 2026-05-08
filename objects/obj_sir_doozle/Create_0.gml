// Run the parent (obj_character_parent) Create event to set up shared character properties
// (vel_x/vel_y, gravity, friction, hp, grounded, etc.).
event_inherited();

// Sir Doozle walks on his own — slightly faster than the basic enemy, but tunable from here.
move_speed = 3;

// Direction the knight is heading. 1 = right, -1 = left. He side-scrolls to the right by default.
walk_dir = 1;

// Kick off his walk so he's already moving the moment the room starts.
vel_x = move_speed * walk_dir;

// Knights are not defeated like the player — give him plenty of hp so the template's
// "hp <= 0" replace-with-defeated-object logic in obj_character_parent never triggers.
max_hp = 999;
hp = max_hp;
