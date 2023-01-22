extends Node


signal save
signal show_tab
signal set_cancel

var stats

var tutorial = true
var inhibit_for_stats = false
var tutorial_progress = 0
var stats_progress = 0
var prevent_dealcount = false


func show_tabs(uninhibit=false):
	if tutorial_progress < 3:
		emit_signal("set_cancel", false)
	else:
		emit_signal("set_cancel", true)
	if tutorial_progress >= 2:
		emit_signal("show_tab","StatsView")

	if uninhibit and inhibit_for_stats:
		inhibit_for_stats = false
		emit_signal("save")

	if inhibit_for_stats:
		return

	if tutorial_progress >= 1:
		emit_signal("show_tab","WorldView")
	if tutorial_progress >= 3:
		emit_signal("show_tab","SaveView")
	if tutorial_progress >= 4:
		emit_signal("show_tab","ScoreView")


func _on_Deal_count(prev, count):
	if tutorial_progress < 1 and prev > 0 and count <= 0:
		if prevent_dealcount:
			prevent_dealcount = false
			return
		tutorial_progress = 1
		show_tabs()


func _on_Fight_win_height(col):
	if col == 4 and tutorial_progress < 3:
		tutorial_progress = 3
		tutorial = false
	if tutorial_progress < 2 and stats.xp > 0:
		tutorial_progress = 2
	progress_stats()


func progress_stats():
	if stats_progress >= 5:
		return
	var stat = stats.list[stats_progress]
	if stats.unlocked-1 >= stats_progress and stats.xp >= stat.cost():
		stats_progress += 1
		inhibit_for_stats = true


func _on_Stats_buy_pressed():
	if inhibit_for_stats:
		show_tabs(true)


func on_ending():
	if tutorial_progress < 4:
		tutorial_progress = 4


func set_tutorial(t, s):
	tutorial = true
	tutorial_progress = t
	inhibit_for_stats = false
	if t >= 3:
		tutorial = false
	stats_progress = s
	prevent_dealcount = false
	if t < 1:
		prevent_dealcount = true

