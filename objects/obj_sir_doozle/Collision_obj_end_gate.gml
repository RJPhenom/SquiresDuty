// Sir Doozle has reached the end gate. Hand off to obj_doozle_end_level for
// the walk-to-center + fade-out teleport sequence. The global flag that
// unlocks Grizzelda's gate gets set when his fade finishes, so she can ONLY
// enter the gate AFTER he's fully teleported through.
instance_create_layer(x, y, layer, obj_doozle_end_level);
instance_destroy();
