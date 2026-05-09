// Marker for legal bridge spans. Pairs of markers at the same Y get filled
// in by Grizzelda's wood-placement when she's nearby — each cell becomes an
// obj_bridge_segment (wood-plank visual). See player_use in obj_player's
// Create event for the spawn logic. The marker itself has no runtime
// behavior; it's purely a position + sibling-pair signal.
