// On animation end: freeze the jump and fall sprites on their last frame so they
// don't loop while the player is still in the air.
switch (sprite_index)
{
	case spr_grizzelda_jump:
	case spr_grizzelda_fall:
		image_speed = 0;
		image_index = image_number - 1;
		break;
}
