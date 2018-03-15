extends Area2D #player

signal nb_mov(name_fr,pos_old_fr,dif_pos_fr)

const tile_size=Vector2(795,460) #isometric with rounding
var velocity=Vector2() #norm dif_pos
var dif_pos=Vector2()
var pos_old=Vector2()
var nb_grp_arr=[] #neighbours group array ((should be) contains 0-2 items)


func sprite_str(): #safe function for returning sprite information
	return $AnimatedSprite.animation


func sprite_change(): #function for changing my value in mod6 (1,..,6; with my cycling protect) using sprites
	var spr_str=sprite_str()
	var typ=int(spr_str[0])
	var com=int(spr_str[1])
	var num=int(spr_str[2])
	if (velocity.x > 0)or(velocity.y < 0):
        if num==6:
            num=1
        else:
            num+=1
	if (velocity.x < 0)or(velocity.y > 0):
        if num==1:
            num=6
        else:
            num-=1
	$AnimatedSprite.animation=str(100*typ+10*com+num)


func _ready():
	
	pos_old=position
	var my_seed = "Pry je tohle random generator" #ale cas je lepsi
	seed(OS.get_unix_time()) #seed(my_seed.hash())
	var rand_typ = randi()%2 +1
	var rand_val = 6#randi()%6 +1
	$AnimatedSprite.animation = str(100*rand_typ +10+ rand_val) #random choise of character (typ and val), +10 for leaders


#	hide()
#	screensize = get_viewport_rect().size

#func start(pos):
	#position = pos
	#show()
	#$Collision.disabled = false


func _process(delta):

	if Input.is_action_just_pressed("ui_right"):
		velocity.x += 1
	elif Input.is_action_just_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_just_pressed("ui_down"):
		velocity.y += 1
	elif Input.is_action_just_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		dif_pos = Vector2(tile_size.x/2*(velocity.x-velocity.y),tile_size.y/2*(velocity.x+velocity.y)) #isometric kinematic; important
		pos_old = position #old position
		position += dif_pos #new position

		sprite_change() #change my value when I'm move
		if !nb_grp_arr.empty(): #if array isn't empty
			emit_signal("nb_mov",get_name(),pos_old,dif_pos) #emit when I'm move in group
	velocity=Vector2(0,0) 





func _on_player_area_shape_entered(area_id, area, area_shape, self_shape):
	#print(self.get_name(),self,self.position,self.sprite_str()," entered with\\nNAME:",area.get_name()," ID:",area_id," POS:",area.position," SPRITE:",area.sprite_str())
	var val_you_int = int(area.sprite_str()[2])
	var val_me_int = int(self.sprite_str()[2])
	if val_you_int>val_me_int:
		print("ja ",self.get_name()," mam smulu.") #pracovni
	elif val_you_int<val_me_int:
		print("ja ",self.get_name()," jsem vudce.") #pracovni
	elif val_you_int==val_me_int:
		print("ja ",self.get_name()," mam pritele.") #pracovni
		var fr_name = area.get_name() #safe var
		if !nb_grp_arr.has(fr_name): #if area still isn't neighbour
			nb_grp_arr.append(fr_name); #add new neighbour in group
			var name_fr=self.get_name()
			var pos_old_fr=pos_old
			var dif_pos_fr=dif_pos
			self.connect("nb_mov",area,"nb_mov") #create (command) new target signal nb_mov; important - to nechapu ale argumenty zde musim vynechat aby to fungovalo
			print("entered_connect command created ",area)

func _on_player_area_shape_exited(area_id, area, area_shape, self_shape):
	var fr_name = area.get_name() #safe var
	if nb_grp_arr.has(fr_name):
		print("ERROR: leaving friend ",fr_name)
