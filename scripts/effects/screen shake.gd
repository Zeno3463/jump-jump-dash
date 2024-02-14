extends Camera2D

# The amount of camera shake
var shake_amount = 0

# A flag to track if the camera shake is finished
var done := false

func _process(delta):
	# If the camera shake is finished, return
	if done:
		return
	
	# Calculate a random offset for the camera shake
	offset = Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	) * delta

# Function to initiate a camera shake
func shake(amplitude=100, time=0.4, amplitude_limit=100):
	# Reset the done flag
	done = false
	
	# Increase the shake amount by the specified amplitude
	shake_amount += amplitude
	
	# Limit the shake amount to the amplitude limit
	if shake_amount > amplitude_limit:
		shake_amount = amplitude_limit
	
	# Start a timer with the specified time duration
	$Timer.wait_time = time
	$Timer.start()

# This function is called when the timer times out
func _on_timer_timeout():
	# Reset the shake amount and camera offset
	shake_amount = 0
	offset = Vector2.ZERO
	
	# Set the done flag to indicate that the camera shake is finished
	done = true
	
	# Stop the timer
	$Timer.stop()
