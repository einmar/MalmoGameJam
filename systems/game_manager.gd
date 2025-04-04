extends Node

var references = {}
var player: RigidBody2D

# Global references
func add(key: String, value):
	references[key] = value

func remove(key: String):s
	if references.has(key):
		references.erase(key)
		return true
	return false

func clear_references():
	references.clear()

func fetch(key):
	if references.has(key):
		return references[key]
	return null
