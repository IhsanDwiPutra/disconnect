extends Node

# --- Referensi Node---
@export var study_bar : ProgressBar
@export var hp_mesh: MeshInstance3D # Mesh HP
@export var sfx_notif : AudioStreamPlayer # Suara Notif

# --- Variabel ---
var study_progress = 0.0
var study_speed = 15.0 # Kecepatan nambah per detik
var is_phone_triggered = false

func _ready() -> void:
	# Pastikan HP mati dulu warnanya
	matikan_layar_hp()

func _process(delta: float) -> void:
	# 1. Logika Belajar
	if Input.is_action_pressed("interact") and not is_phone_triggered:
		study_progress += study_speed * delta
		study_bar.value = study_progress
		
		# Cek apakah sudah 50%?
		if study_progress >= 50.0:
			trigger_hp_bunyi()
	
	elif study_progress > 0 and not is_phone_triggered:
		study_progress -= 5.0 * delta
		study_bar.value = study_progress

# --- Fungsi Event
func trigger_hp_bunyi():
	is_phone_triggered = true
	print("HP BUNYI! GANGGUAN DATANG")
	
	# Mainkan suara
	if sfx_notif:
		sfx_notif.play()
	
	# Nyalakan Layar HP (Visual)
	nyalakan_layar_hp()

func matikan_layar_hp():
	var material = hp_mesh.get_active_material(0)
	if material:
		material.emission_enabled = false

func nyalakan_layar_hp():
	var material = hp_mesh.get_active_material(0)
	if material:
		material.emission_enabled = true
		material.emission = Color(0, 0.8, 1) # Warna Biru Langit Terang
		material.emission_energy_multiplier = 2.0 # Terang
