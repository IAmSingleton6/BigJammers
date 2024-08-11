extends Node
class_name FeelController

# Official docs:

# To use:
# To play, call play() on the FeelController

# Setup:
# Add feel controller scene to the scene where you want to use 
# Add however many feel package scenes as you want to play (they will all play in parallel)
# Add feel component scenes to the feel packages
# Each feel component in a feel package will play in order

# Feel Controller:
# Controls playback of the entire system, and contains one or more Feel packages to play the feedback

# Feel Package:
# Contains feel components which will create a series of actions on play
# Will play in order of tree hierarchy (top to bottom)
# Name of nodes does not matter, only that the class inherits from FeelComponent

# Feel Component:
# Contains logic to create feedback on play (eg screenshake or bloom)
# Order variable determines when the component will play:
# Sequential -> Wait for all prior components to finish playing before playing
# Parallel   -> Play immediately

# FeelPause:
# Special type of feel component which pauses FeelPackage play execution until timer finishes
# If next component has an order of Parallel, it will play once the timer is finished
# If next component has an order of Sequential, it will play once the timer is finished -
# and all previous nodes have finished playback

# Create your own FeelComponent:
# extends FeelComponent
# class_name Feel#NameOfClass#
#
# func play() -> void:
#	#function logic#
#	#stop()
#
# play -> called once the package manager reaches its turn in the tree execution order
# IMPORTANT -> #stop()# must be called once the component has finished, allowing 
# execution to continue for the other components in the package

var playing: bool = false
var feel_component_managers: Array[FeelPackage] = []
var active_component_managers: int = 0


# Remove the child component managers in the tree and store a copy of them
func _ready() -> void:
	for child in get_children():
		if child is FeelPackage:
			feel_component_managers.append(child)
			child.finished.connect(on_component_manager_finished)
			remove_child(child)


# Instantiate a copy of each of the components and play them 
func play() -> void:
	if feel_component_managers.size() < 1:
		return
	
	playing = true
	for component_manager in feel_component_managers:
		# duplicate as the component will destroy itself on completion
		var new_component_manager := component_manager.duplicate()
		add_child(new_component_manager)
		#new_component_manager.finished.connect(on_component_manager_finished)
		new_component_manager.play()
		active_component_managers += 1


func on_component_manager_finished() -> void:
	active_component_managers -= 1
	if active_component_managers < 1:
		if active_component_managers < 0:
			push_error("Less than one active feel component manager")
			active_component_managers = 0
			return
		playing = false


func _on_player_level_win():
	pass # Replace with function body.
