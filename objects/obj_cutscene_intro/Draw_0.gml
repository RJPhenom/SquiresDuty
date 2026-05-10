// Draw (not Draw GUI) — renders to the application surface where video_draw
// expects to write. Drawing this in Draw GUI hid the output because the GUI
// surface composites OVER the application surface and video_draw is rendered
// at the application-surface layer.
var _videoData = video_draw();

var _videoStatus = _videoData[0];

if (_videoStatus == 0)

{

draw_surface(_videoData[1],0,0);

}
