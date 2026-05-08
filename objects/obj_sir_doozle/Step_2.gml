// Run the parent End Step (sprite flipping, defeat handling, invincibility flashing).
event_inherited();

// The parent's Begin Step applies friction and the Step zeroes vel_x on wall collisions,
// so re-assert the walking velocity here so Sir Doozle keeps marching independently.
// He has no input — this is what makes him auto-side-scroll.
vel_x = move_speed * walk_dir;
