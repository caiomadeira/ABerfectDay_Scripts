extends Node

const six_am = 60 * 6 # wake up hour
const nine_am = 60 * 9 # go to work hour
const sixteen_pm = 60 * 18 # back to work hour

var time = six_am
var is_timer_on: bool = true
var secs_passed: float = 0.0
var mins_passed: float = 0.0

func _start_time(delta):
	if(is_timer_on):
		time += delta / 6
		#time += delta / 2
		
	var mils = fmod(time, 1) * 1000
	var secs = fmod(time, 60)
	var mins = fmod(time, 60 * 60) / 60
	
	secs_passed = secs
	mins_passed = mins

func start_global_clock(delta):
	_start_time(delta)
	var clock_mins = secs_passed 
	var clock_hours = mins_passed
	
	var time_passed = "%02d:%02d" % [clock_hours, clock_mins]
	return time_passed
