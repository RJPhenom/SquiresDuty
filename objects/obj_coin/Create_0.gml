event_inherited();

// obj_coin keeps its sprite-based animation from the template, but is now a generic
// pickup that lands on Grizzelda's backpack stack. Override item identity here.
item_type	= "coin";
item_label	= "C";
item_color	= make_color_rgb(240, 200, 70);	// gold
item_height	= 24;

// Random starting frame so a row of coins doesn't animate in lockstep.
image_index = irandom_range(0, image_number - 1);
