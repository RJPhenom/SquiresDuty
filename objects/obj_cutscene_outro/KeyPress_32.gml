// Skip cutscene with Space → straight back to the main menu.
if (advancing) exit;

video_close();
advancing = true;
room_goto(rm_menu);
