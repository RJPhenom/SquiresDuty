// Skip cutscene with Space.
if (advancing) exit;

video_close();
advancing = true;
room_goto_next();
