class_name HeapEdge
extends AnimatedSprite2D

enum State { VALID, INVALID, SORTED }

const ANIMATIONS: Array[StringName] = [&"valid", &"invalid", &"sorted"]

@export var customFrames: SpriteFrames
@export var thickness: float = 6.0

var edgeState: State = State.VALID
var length: float = 1.0


func _ready() -> void:
	z_index = -1
	sprite_frames = customFrames if customFrames != null else buildDefaultFrames()
	setState(State.VALID, true)


func connectPoints(from: Vector2, to: Vector2) -> void:
	position = (from + to) / 2.0
	rotation = (to - from).angle()
	length = from.distance_to(to)
	applyScale()


func setState(newState: State, force: bool = false) -> void:
	if newState == edgeState and not force:
		return
	edgeState = newState
	play(ANIMATIONS[newState])
	applyScale()


func applyScale() -> void:
	if sprite_frames == null:
		return
	var texture := sprite_frames.get_frame_texture(animation, 0)
	if texture == null:
		return
	scale = Vector2(length / texture.get_width(), thickness / texture.get_height())


static func buildDefaultFrames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	addAnimation(frames, &"valid", [Color(0.25, 0.8, 0.35)], 1.0)
	addAnimation(frames, &"invalid", [Color(0.9, 0.2, 0.2), Color(0.55, 0.1, 0.1)], 3.0)
	addAnimation(frames, &"sorted", [Color(0.45, 0.45, 0.5)], 1.0)
	return frames


static func addAnimation(frames: SpriteFrames, animationName: StringName, colors: Array, speed: float) -> void:
	frames.add_animation(animationName)
	frames.set_animation_speed(animationName, speed)
	frames.set_animation_loop(animationName, true)
	for color in colors:
		frames.add_frame(animationName, solidTexture(color))


static func solidTexture(color: Color) -> ImageTexture:
	var image := Image.create(16, 4, false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
