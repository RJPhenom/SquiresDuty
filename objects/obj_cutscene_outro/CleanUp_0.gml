// Belt-and-suspenders close, in case the instance is destroyed without
// going through the Step/skip path (e.g., room hard-restart).
video_close();
