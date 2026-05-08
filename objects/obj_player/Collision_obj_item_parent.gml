// Pick up the item: snapshot its world sprite onto the backpack and despawn it.
backpack_push(other.item_type, other.sprite_index, other.item_height);

// Reuse the coin VFX/SFX so collection still feels punchy.
instance_create_layer(other.x, other.y, "Instances", obj_coin_collect_effect);
audio_play_sound(snd_coin_collect_01, 0, 0);

instance_destroy(other);
