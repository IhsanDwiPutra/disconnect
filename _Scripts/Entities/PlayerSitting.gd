extends Node3D

# --- Referensi ---
@onready var camera= $Camera3D
@onready var raycast = $Camera3D/RayCast3D

# Referensi UI
@export var prompt_label: Label
@export var study_bar: ProgressBar
@export var sfx_notif: AudioStreamPlayer
@export var hp_mesh: MeshInstance3D
@export var mobile_ui : Control

# --- Setting Kamera ---
var mouse_sensitivity = 0.002
# Batas Nengok
var min_pitch = -65.0 # Batas Bawah
var max_pitch = 45.0 # Batas Atas
var min_yaw = -10.0 # Batas Kiri
var max_yaw = 10.0 # Batas Kanan

# --- Logika Game ---
var study_progress = 0.0
var hp_sudah_bunyi = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Reset UI
	prompt_label.text = ""
	matikan_layar_hp()

func _input(event):
	# Logika Gerak Mouse
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.y = clamp(rotation.y, deg_to_rad(min_yaw), deg_to_rad(max_yaw))
		
		camera.rotation.x -= event.relative.y * mouse_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

func _process(delta: float) -> void:
	# Reset teks promp setiap frame
	prompt_label.text = ""
	
	# Cek Raycast
	if raycast.is_colliding():
		var benda = raycast.get_collider()
		
		# 1. Kalau Lihat Buku
		if benda.is_in_group("buku"):
			prompt_label.text = "[E] Belajar"
			
			if Input.is_action_pressed("interact") and not hp_sudah_bunyi:
				belajar(delta)
		# 2. Kalau Lihat HP
		elif benda.is_in_group("hp"):
			if hp_sudah_bunyi:
				prompt_label.text = "[E] Cek Notifikasi"
				if Input.is_action_pressed("interact"):
					ambil_hp()
			else:
				# Kalau HP belum bunyi, gak bisa diapa-apain
				prompt_label.text = ""
	
	if not Input.is_action_pressed("interact") and study_progress > 0 and not hp_sudah_bunyi:
		study_progress -= 5.0 * delta
		study_bar.value = study_progress

# --- Fungsi Custom
func belajar(delta):
	study_progress += 15.0 * delta
	study_bar.value = study_progress
	
	# Cek Trigger HP
	if study_progress >= 50.0 and not hp_sudah_bunyi:
		trigger_hp()

func trigger_hp():
	hp_sudah_bunyi = true
	if sfx_notif:
		sfx_notif.play()
	nyalakan_layar_hp()
	print("HP BUNYI! GANGGUAN DATANG!")

func ambil_hp():
	print("Membuka HP...")
	
	set_process_input(false)
	mobile_ui.buka_hp()

func matikan_layar_hp():
	if hp_mesh:
		var mat = hp_mesh.get_active_material(0)
		if mat:
			mat.emission_enabled = false

func nyalakan_layar_hp():
	if hp_mesh:
		var mat = hp_mesh.get_active_material(0)
		if mat:
			mat.emission_enabled = true
			mat.emission = Color.CYAN
			mat.emission_enery_multiplier = 2.0
