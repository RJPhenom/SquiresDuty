// Override obj_enemy_parent.End Step entirely — we DON'T want the wall/ledge
// turn logic, since R is stationary. We still need the hp<=0 → defeat handling
// and invincibility flashing, so we call obj_character_parent's End Step
// directly via event_perform_object.
event_perform_object(obj_character_parent, ev_step, ev_step_end);
