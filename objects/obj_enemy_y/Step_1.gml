// Override obj_character_parent.Begin Step (gravity + friction + grounded check).
// We want NONE of those for a flier — no gravity pulling him down, no friction
// killing his drift, and no "grounded" snapping. Just bob and move.
//
// We deliberately DON'T call event_inherited() here.

bob_t += 4;
y = spawn_y + sin(degtorad(bob_t)) * bob_amplitude;

// vel_x is set in Create / End Step; nothing else to do.
grounded = false;
