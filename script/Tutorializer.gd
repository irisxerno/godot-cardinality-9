extends Node


signal save
signal show_tab
signal set_cancel

var stats

var tutorial = false
var inhibit = 0
var tutorial_progress = 5
var stats_progress = 6
var control = false
var scores = false


func show_tabs(uninhibit=0):
	if tutorial_progress < 3:
		emit_signal("set_cancel", false)
	else:
		emit_signal("set_cancel", true)

	if tutorial_progress >= 2:
		emit_signal("show_tab","StatsView")

	if uninhibit == inhibit:
		inhibit = 0
		emit_signal("save")

	if inhibit > 0:
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
	if stats_progress >= 6:
		return
	var stat = stats.list[stats_progress]
	print(stats.unlocked-1, ">=", stats_progress)
	if stats.unlocked-1 >= stats_progress:
		if stats.xp >= stat.cost():
			stats_progress += 1
			inhibit = 1


func _on_Stats_buy_pressed():
	if inhibit == 1:
		show_tabs(1)


func set_progress(p):
	if typeof(p) < 2: # null or bool
		p = {
			"tutorial": 5,
			"stats": 6
		}
	tutorial = true
	tutorial_progress = p["tutorial"]
	inhibit = 0
	if tutorial_progress >= 3:
		tutorial = false
	stats_progress = p["stats"]
	control = false


func to_data():
	return {
		"tutorial": tutorial_progress,
		"stats": stats_progress
	}
