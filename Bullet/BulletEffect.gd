extends Sprite

#onready var timer := $Timer

#func _process(delta):
	#if timer.is_stopped():
		#queue_free()

func _on_Timer_timeout():
	queue_free()
