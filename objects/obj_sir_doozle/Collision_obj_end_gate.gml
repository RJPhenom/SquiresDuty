// Sir Doozle has reached the end gate. Hand off to obj_doozle_end_level for
// the walk-to-center + fade-out teleport sequence. The global flag that
// unlocks Grizzelda's gate gets set when his fade finishes, so she can ONLY
// enter the gate AFTER he's fully teleported through.
//
// Pass the SPECIFIC gate he hit (other.id) — rooms can have multiple gates
// (e.g. for debugging) and `obj_end_gate.x` would otherwise resolve to the
// first instance, walking him toward the wrong target.
var _end = instance_create_layer(x, y, layer, obj_doozle_end_level);
_end.target_gate = other.id;
instance_destroy();
