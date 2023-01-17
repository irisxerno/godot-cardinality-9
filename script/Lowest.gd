extends Control


func update_text(lowest):
	$Score.text = str(int(lowest["score"]))+"."
	$Time.text = str(int(lowest["time"]/60)) + " m"
	$Progress.text = str(int(lowest["progress"]))+"/90"
