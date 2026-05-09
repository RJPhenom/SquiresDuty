// Identity for the inventory system. Children override these.
// `item_type`: short string key the rest of the game branches on ("sword", "potion", "coin"…).
// `item_label`: short text shown on the colored placeholder block until real art is in.
// `item_color`: drawing color for the placeholder block.
// `item_height`: vertical size of this item in the backpack stack (pixels).
item_type	= "generic";
item_label	= "?";
item_color	= c_white;
item_height	= 28;

// World items get a tiny float so they don't look static lying on the ground.
bob_t = random(360);

// Pickup grace period — set >0 by drop code (Grizzelda's G key, Doozle item
// swap) so the dropping character doesn't immediately re-collide and re-pick
// it up. Decrements in Step_0; collision is gated in obj_player.
no_pickup_frames = 0;
