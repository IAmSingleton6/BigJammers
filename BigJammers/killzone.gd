extends Area2D


func _on_body_entered(body):
	print("lose")
	if body is Player:
		(body as Player).kill()
