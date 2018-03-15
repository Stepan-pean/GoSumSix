extends Area2D #enemy


const tile_size=Vector2(795,460) # isometric with rounding
var velocity=Vector2() # norm dif_pos
var dif_pos=Vector2()
var old_pos=Vector2()
var nb_grp_arr=[] #neighbours group array ((should be) contains 0-2 items)

	
func sprite_str():
	return $AnimatedSprite.animation


func sprite_change(): #works independently of vector norm
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
	old_pos=position
	#seed(1+OS.get_unix_time()) #seed(my_seed.hash())
	var rand_typ = randi()%2 +1
	var rand_val = 3#randi()%6 +1
	$AnimatedSprite.animation = str(100*rand_typ +10+ rand_val) #random choise of character (typ,val)





func nb_mov(fr_name,fr_pos_old,fr_dif_pos): #call function when receive signal from any neighbour
	print("receive: ",fr_name,fr_pos_old,fr_dif_pos)
	old_pos=position
	position=fr_pos_old #following friend
	dif_pos=position-old_pos
	velocity=Vector2(dif_pos.x+dif_pos.y,dif_pos.y-dif_pos.x)/2 #transform isometric->cartesian



func _process(delta):
	if velocity.length() > 0:
		sprite_change()
		velocity=Vector2(0,0)


#	hide()
#	screensize = get_viewport_rect().size

#func start(pos):
	#position = pos
	#show()
	#$Collision.disabled = false



#	if Input.is_action_just_pressed("ui_right"):
#		velocity.x += 1
#	elif Input.is_action_just_pressed("ui_left"):
#		velocity.x -= 1
#	elif Input.is_action_just_pressed("ui_down"):
#		velocity.y += 1
#	elif Input.is_action_just_pressed("ui_up"):
#		velocity.y -= 1
#	velocity = velocity.normalized() * STEP
	#zmena = Vector2(795/2*(velocity.x-velocity.y),460/2*(velocity.x+velocity.y)) #isometric kinematic, klíčkový řádek
#	if (velocity.length() > 0):#and(test_move(position,zmena)):
#        position += zmena #uskutecni se pohyb
#        sprite_change() #moje funkce
#	velocity=Vector2(0,0)






func _on_enemy_area_shape_entered(area_id, area, area_shape, self_shape):
	var val_you_int = int(area.sprite_str()[2])
	var val_me_int = int(self.sprite_str()[2])
	if val_you_int>val_me_int:
		print("ja ",self.get_name()," mam smulu.") #pracovni
	elif val_you_int<val_me_int:
		print("ja ",self.get_name()," jsem vudce.") #pracovni
	elif val_you_int==val_me_int:
		print("ja ",self.get_name()," mam pritele.") #pracovni
		if self.get_name()=="enemy": #upravim az bude vice enemy
			$AnimatedSprite.animation=str(self.sprite_str()[0],"0",self.sprite_str()[2]) #zpruhledneni

		

func _on_enemy_area_shape_exited(area_id, area, area_shape, self_shape):
	pass

