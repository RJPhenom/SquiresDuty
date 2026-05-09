// Draw the arrow rotated to match its travel direction. image_angle is set by
// the spawner once at fire time — we don't recompute from velocity each frame
// so the visual stays clean even if the arrow drifts after a glancing miss.
draw_self();
