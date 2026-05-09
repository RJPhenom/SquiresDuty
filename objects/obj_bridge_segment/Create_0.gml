// Visual-only y offset for the rendered sprite. Collision (bbox) stays at the
// instance's actual y — only the drawn pixels shift. Bump 1 at a time until
// the bridge tops visually align with surrounding platforms.
//   negative = sprite drawn higher
//   positive = sprite drawn lower
visual_y_offset = 1;
