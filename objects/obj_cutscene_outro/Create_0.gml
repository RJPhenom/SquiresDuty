// Intro cutscene player. Streams the included intro .mp4, draws it to the GUI
// surface, watches for end-of-stream in Step, then advances to the next room
// (room1 — the first gameplay level — given the current RoomOrderNodes).
//
// Music: stop everything so the video's own audio comes through cleanly.
// persistent_manager.Other_4 has a guard that already skips the gameplay
// music for this room, but we belt-and-suspenders here in case any music
// was carried over from the menu.
audio_stop_all();

// video_open is the only video function we definitively need here.
// Volume defaults to whatever's in the encoded file. If you need explicit
// volume control later, video_set_volume(volume) exists in newer runtimes
// but isn't guaranteed across versions.
video_open("Squire's Duty Outro.mp4");

// Cutscene state:
//   advancing  — set when the room transition is kicked off, so we don't
//                double-fire room_goto_next from Step + KeyPress.
//   fail_timer — total cutscene length in FRAMES at 60fps. Default 60s.
//                Set this to roughly your video's runtime + a tiny buffer.
//                Player can always skip via Space if it's too long.
advancing	= false;
fail_timer	= 60 * 24;
