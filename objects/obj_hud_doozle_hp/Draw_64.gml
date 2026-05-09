// Sir Doozle health bar — drawn on the GUI layer, top-center of the screen.
// Layout: label on top, bar directly below it.
if (!instance_exists(obj_sir_doozle)) exit;

var _doozle	= instance_find(obj_sir_doozle, 0);
var _gui_w	= display_get_gui_width();

// Layout geometry. We use the HUD font and measure its actual rendered height
// instead of hardcoding — ft_hud is large, and a fixed _label_h was too small,
// causing the bar to fall back into the text.
draw_set_font(ft_hud);

var _label_text	= "SIR DOOZLE  " + string(_doozle.hp) + " / " + string(_doozle.max_hp);
var _label_h	= string_height(_label_text);

var _top_margin	= 16;
var _gap		= 8;
var _bar_w		= 360;
var _bar_h		= 22;

var _bar_x		= (_gui_w - _bar_w) / 2;
var _label_y	= _top_margin;
var _bar_y		= _top_margin + _label_h + _gap;

var _frac		= clamp(_doozle.hp / _doozle.max_hp, 0, 1);
var _fill_w		= _bar_w * _frac;

// Label first so the bar draws on top of any descender shadows cleanly.
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(_gui_w / 2, _label_y, _label_text);

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

// Reset draw state.
draw_set_halign(fa_left);
draw_set_valign(fa_top);
