extends Control

func _ready():
	hide()
	$FadeOverlay.visible = false

func buka_hp():
	print("Halo")
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_button_pressed():
	print("Game dimulai... Rian terjebak!")
	$FadeOverlay.visible = true
	
	$AnimationPlayer.play("fade_to_black")
	
	await $AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_file("res://Scenes/Levels/KamarPagi.tscn")
