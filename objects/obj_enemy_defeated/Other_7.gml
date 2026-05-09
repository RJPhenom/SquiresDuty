// Animation End — the death animation has finished, so destroy the corpse.
// Same pattern as obj_enemy1_defeated; we just point at spr_death which is the
// shared death sprite for the new R/Y/B family.
instance_destroy();
