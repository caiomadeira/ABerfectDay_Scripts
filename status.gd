extends Control

@onready var debug_label = $sleep_status/DebugLabel
@onready var sleep_variables = $sleep_status/SleepVariables
@onready var sleep_progressbar = $sleep_status/ProgressBar

func _ready():
	hide()

func _sleep_variables() -> int:
	var count = 0
	if GlobalScript.lampshade_on:
		sleep_variables.text = "\n[!] Some light is on\n"
		count += 1
	if GlobalScript.rooftop_light_on:
		sleep_variables.text = "\n[!] Some light is on\n"
		count += 1
		
	print("Sleep Variables Count: " + str(count))
	return count

		
func _increase_sleep_progress() -> int:
	var progress_value = 0.0
	match _sleep_variables():
		# zero is the ideal scenery
		0:
			progress_value += 7
		1:
			progress_value += 3
		2:
			progress_value += 2
		3:
			progress_value += 1
		_:
			progress_value += 0
			
	return progress_value

func _on_sleep_timer_timeout():
	debug_label.text = "ProgressBarValue: " + str(sleep_progressbar.value)
	if GlobalScript.is_resting and GlobalScript.is_eyes_closed:
		if sleep_progressbar.value < 100:
			show()
			sleep_progressbar.value += _increase_sleep_progress()
		else:
			hide()
	else:
		hide()
		sleep_variables.text = ""
		sleep_progressbar.value = 0.0
