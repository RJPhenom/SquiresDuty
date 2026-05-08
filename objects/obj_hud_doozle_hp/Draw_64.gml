// Sir Doozle health bar — drawn on the GUI layer, top-center of the screen.
if (!instance_exists(obj_sir_doozle)) exit;

var _doozle	= instance_find(obj_sir_doozle, 0);
var _gui_w	= display_get_gui_width();

// Bar geometry.
var _bar_w		= 360;
var _bar_h		= 22;
var _bar_x		= (_gui_w - _bar_w) / 2;
var _bar_y		= 24;

var _frac		= clamp(_doozle.hp / _doozle.max_hp, 0, 1);
var _fill_w		= _bar_w * _frac;

// Drop shadow.
draw_set_alpha(0.4);
draw_set_color(c_black);
draw_rectangle(_bar_x + 3, _bar_y + 3, _bar_x + _bar_w + 3, _bar_y + _bar_h + 3, false);
draw_set_alpha(1);

// Empty track.
draw_set_color(make_color_rgb(40, 30, 30));
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

// Fill — color shifts from green → yellow → red as hp drains.
var _fill_col;
if (_frac > 0.6)		_fill_col = make_color_rgb(120, 200, 90);
else if (_frac > 0.3)	_fill_col = make_color_rgb(230, 190, 70);
else					_fill_col = make_color_rgb(220, 80, 60);

draw_set_color(_fill_col);
draw_rectangle(_bar_x, _bar_y, _bar_x + _fill_w, _bar_y + _bar_h, false);

// Outline.
draw_set_color(c_white);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

// Label.
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_bar_x + _bar_w / 2, _bar_y + _bar_h / 2, "SIR DOOZLE  " + string(_doozle.hp) + " / " + string(_doozle.max_hp));
draw_set_halign(fa_left);
draw_set_valign(fa_top);
