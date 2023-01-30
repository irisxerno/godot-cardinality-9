extends Node


signal save
signal show_tab
signal set_cancel
signal enable_worldsaves

var stats

var tutorial = false
var inhibit_for_stats = false
var tutorial_progress = 5
var stats_progress = 6
var control = false
var scores = false


func show_tabs(uninhibit=false):
	if tutorial_progress < 3:
		emit_signal("set_cancel", false)
	else:
		emit_signal("set_cancel", true)
	
	if tutorial_progress < 4:
		emit_signal("enable_worldsaves", false)
	else:
		emit_signal("enable_worldsaves", true)
	
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
	if scores:
		emit_signal("show_tab","ScoreView")
	control = true


func _on_Deal_count(count):
	if tutorial_progress < 1 and count <= 0 and control:
		tutorial_progress = 1
		show_tabs()


func on_win(col, w_num):
	if col == 4:
		if tutorial_progress < 3:
			tutorial_progress = 3
			tutorial = false
		if w_num > 0 and tutorial_progress < 4:
			tutorial_progress = 4
	if tutorial_progress < 2 and stats.xp > 0:
		tutorial_progress = 2
	progress_stats()


func progress_stats():
	# TODO: this doesn't work??????
	stats.pending_tutorial = false
	if stats_progress >= 5:
		return
	var stat = stats.list[stats_progress]
	if stats.unlocked-1 >= stats_progress:
		if stats.xp >= stat.cost():
			stats_progress += 1
			inhibit_for_stats = true
		else:
			stats.pending_tutorial = stats_progress


func _on_Stats_buy_pressed():
	if inhibit_for_stats:
		show_tabs(true)


func set_progress(p):
	if typeof(p) < 2: # null or bool
		p = {
			"tutorial": 5,
			"stats": 6
		}
	tutorial = true
	tutorial_progress = p["tutorial"]
	inhibit_for_stats = false
	if tutorial_progress >= 3:
		tutorial = false
	stats_progress = p["stats"]
	control = false
	stats.pending_tutorial = false
	if stats.unlocked-1 >= stats_progress and stats.xp < stats.list[stats_progress].cost():
		stats.pending_tutorial = stats_progress


func to_data():
	return {
		"tutorial": tutorial_progress,
		"stats": stats_progress
	}
