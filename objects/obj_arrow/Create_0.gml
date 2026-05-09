// Defaults — the spawner overwrites vel_x/vel_y/team/damage/image_angle as needed.
//
// team:    "knight" → friendly, only damages obj_enemy_parent
//          "enemy"  → hostile,  only damages obj_player
//          (Set on spawn so we don't friendly-fire Doozle with R's arrows or
//           clip our own knight on his crossbow shot.)
team	= "enemy";
damage	= 25;
vel_x	= 0;
vel_y	= 0;

// Despawn after a couple of seconds even if we never hit anything (off-screen
// arrows still tick gravity / collision otherwise).
lifespan = 180;
