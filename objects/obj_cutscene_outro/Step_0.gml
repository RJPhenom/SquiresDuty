// Fixed-duration timer for advancing past the cutscene. The video API in
// this GM version doesn't expose reliable end-of-stream detection, so we
// just count frames at 60fps and advance after the timer expires.
//
// Tune `fail_timer` in Create_0 to match your actual video length (frames at
// 60fps — e.g. 60*30 for a 30-second intro). The player can always Space-
// to-skip via the KeyPress event if this is set too long.
if (advancing) exit;

fail_timer -= 1;
if (fail_timer <= 0)
{
	video_close();
	advancing = true;
	// Outro always routes back to the main menu, regardless of room order.
	room_goto(rm_menu);
}
