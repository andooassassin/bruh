pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
n_players = 2
start_pos = {8,40,72,104}






function _init()
 music(0,1)
 init_one()
 global={}
 global.zdown = false
 global.zup = false
 global.zpressed = false
 global.xdown = false
 global.xup = false
 global.xpressed = false
 global.shaketimer = 0
 global.timer = 0
 global.enemies = 5
 global.enemiespunched = 0
 global.fadeintimer = 24
 
 player={}
 player.x = 58
 player.y = 64
 player.isplayer = true
 player.facingleft = false
 player.sprite = 0
 player.speed = 1
 player.defaultspeed = 1
 player.chargespeed = .5
 player.kickchargespeed = .5
 player.punchspeed = 8
 player.kickspeed = 8
 player.punchtimer = 0
 player.kicktimer = 0
 player.moving = false
 player.charging = false
 player.kickcharging = false
 player.punching = false
 player.kicking = false
 player.state = 0
 player.at = 0
 player.life = 3
 player.ishurt = false
 player.hurttimer = 0
 player.recoiltimer = 0
 player.isdead = false
 player.deadtimer = 11

 
 player2={}
 player2.x = 62
 player2.y = 64
 player2.isplayer = true
 player2.facingleft = false
 player2.sprite = 32, 1, 2
 player2.speed = 1
 player2.defaultspeed = 1
 player2.chargespeed = .5
 player2.kickchargespeed = .5
 player2.punchspeed = 8
 player2.kickspeed = 8
 player2.punchtimer = 0
 player2.kicktimer = 0
 player2.moving = false
 player2.charging = false
 player2.kickcharging = false
 player2.punching = false
 player2.kicking = false
 player2.state = 0
 player2.at = 0
 player2.life = 3
 player2.ishurt = false
 player2.hurttimer = 0
 player2.recoiltimer = 0
 player2.isdead = false
 player2.deadtimer = 11

end
-->8
function move(o)
    if not o.isplayer then
        return
    end
    player.moving = true
    // dont do walking anim if punch
    if (player.punching == false and
        player.charging == false and
        player.kicking == false and
        player.kickcharging == false) then
     if player.sprite == 0 then
         if player.ishurt then
             player.sprite = 14 // dirty hack
         else
             player.sprite = 2
         
            end
        elseif player.sprite != 0 then
            player.sprite = 0
        end
       
 end
 player2.moving = true
    // dont do walking anim if punch
    if (player2.punching == false and
        player2.charging == false and
        player2.kicking == false and
        player2.kickcharging == false) then
     if player2.sprite == 32 then
         if player2.ishurt then
             player2.sprite = 14 // dirty hack
         else
             player2.sprite = 35
         
            end
        elseif player2.sprite != 32 then
            player2.sprite = 32
        end
       
 end
end

function movex(o,v)
    if v == 0 then return end
    move(o)
    o.x += v

 local collisions = cmap(o)
 if (collisions.l or collisions.r) then
     o.x -= v
     movex(o,v/2)
     if (o.isenemy == true and
         o.ispunched == true) then
         o.ispunched = false
            killenemy(o)
     end
 end
    


end


function movey(o,v)
    if v == 0 then return end
    move(o)
    o.y += v
   
 local collisions = cmap(o)
 if (collisions.t or collisions.b) then
     o.y -= v
     movey(o,v/2)
 end
   end 

function kickcharge()
    player.kickcharging = true
    player.sprite = 3
    player.kickspeed = 3
    sfx(3,2)
   
    player2.kickcharging = true
    player2.sprite = 35
    player2.kickspeed = 3
    sfx(3,2)
    end
  
    
    function updatekickcharge()
 if player.kickspeed < 12 then
     player.kickspeed += .25
    end
    if player.kickspeed == 8 then
     sfx(7,2)
    elseif player.kickspeed == 11 then
        sfx(8,2)
    end
    player.sprite += 1
    if player.sprite > 5 then
        player.sprite = 3
    end
    if player2.kickspeed < 12 then
     player2.kickspeed += .25
    end
    if player2.kickspeed == 8 then
     sfx(7,2)
    elseif player2.kickspeed == 11 then
        sfx(8,2)
    end
    player2.sprite += 33
    if player2.sprite > 36 then
        player2.sprite = 34
    end
end

function charge()
    player.charging = true
    player.sprite = 3
    player.punchspeed = 3
    sfx(3,2)
end

function updatecharge()
 if player.punchspeed < 12 then
     player.punchspeed += .25
    end
    if player.punchspeed == 8 then
     sfx(7,2)
    elseif player.punchspeed == 11 then
        sfx(8,2)
    end
    player.sprite += 1
    if player.sprite > 3 then
        player.sprite = 3
    end
end

function kick()
    global.start = true
    player.kicking = true
    player.sprite = 6,2,2
    player.kicktimer = 0
    sfx(4,2)
   
    player2.kicking = true
    player2.sprite = 6,2,2
    player2.kicktimer = 0
    sfx(4,2)
end

function updatekick()
    if (player.kicking == true) then
        player.kicktimer += 1
        if player.sprite < 5 then
            player.sprite += 1
        end
       
     // punchmovement
     local prevx = player.x
     local prevy = player.y
     local movespeed = player.kickspeed
     if (player.kicktimer > 8) then
         movespeed = player.kickchargespeed
     end
     if player.facingleft then
         movex(player,-movespeed)
     else
      movex(player,movespeed)
  end
    end
    // cooldown
    if (player.kicktimer > 16) then
        player.kicking = false
        player.sprite = 0
        player.kicktimer = 0
    end
    if (player2.kicking == true) then
        player2.kicktimer += 1
        if player2.sprite < 36 then
            player2.sprite += 33
        end
       
     // punchmovement
     local prevx = player2.x
     local prevy = player2.y
     local movespeed = player2.kickspeed
     if (player2.kicktimer > 8) then
         movespeed = player2.kickchargespeed
     end
     if player2.facingleft then
         movex(player2,-movespeed)
     else
      movex(player2,movespeed)
  end
    end
    // cooldown
    if (player2.kicktimer > 16) then
        player2.kicking = false
        player2.sprite = 32
        player2.kicktimer = 0
    end
end

function punch()
    global.start = true
    player.punching = true
    player.sprite = 4
    player.punchtimer = 0
    sfx(4,2)
end

function updatepunch()
    if (player.punching == true) then
        player.punchtimer += 1
        if player.sprite < 4 then
            player.sprite += 1
        end
       
     // punchmovement
     local prevx = player.x
     local prevy = player.y
     local movespeed = player.punchspeed
     if (player.punchtimer > 8) then
         movespeed = player.chargespeed
     end
     if player.facingleft then
         movex(player,-movespeed)
     else
      movex(player,movespeed)
  end
    end
    // cooldown
    if (player.punchtimer > 16) then
        player.punching = false
        player.sprite = 0
        player.punchtimer = 0
    end
end

function hurtplayer(v)
    if player.hurttimer <= 0 and
        player.punching == false then
        player.ishurt = true
  player.life -= 1
  player.hurttimer = 48
  player.sprite = 14
  player.recoiltimer = 10
  player.recoilspeed = v
  global.shaketimer = 10
  sfx(6,2)
 end
end

function updatehurt()
    if player.life == 0 and player.isdead == false then
        player.isdead = true
        music(2)
        return
    end
    if player.ishurt == false then
        return
    end
    if player.recoiltimer > 0 then
        player.x += player.recoilspeed
        player.recoiltimer -= 1
        player.x = max(16,
            min(player.x,114))
    end
    player.hurttimer -= 1
    if player.sprite == 14 then
     player.sprite = 15
    elseif player.sprite == 15 then
        player.sprite = 14
    end
   
    if player.hurttimer == 0 then
        player.ishurt = false
        player.sprite = 1
    end

end

function change_state()
player.state = s 
player.at =  0
end

-->8
function _update()


	for p in all (players) do
		update_one(p)
	end
    if global.start then
        global.timer += 1
    else
        fade_scr(global.fadeintimer/24)
        global.fadeintimer -= 1
    end
   
    player.moving = false
    player.speed = player.defaultspeed
    if player.charging == true then
        player.speed = player.chargespeed
    end
    if player.punching == false and
        player.recoiltimer == 0 then
     if (btn(0)) then
         player.facingleft = true
         movex(player,-player.speed)
         sfx(3)
     end
     if (btn(1)) then 
         player.facingleft = false
         movex(player,player.speed)
         sfx(5)
     end
     if (btn(2)) then
         movey(player,-player.speed)
         sfx(3)
     end
     if (btn(3)) then
         movey(player,player.speed)
         sfx(5)
     end

 end
   
    updatebtnz()
    updatepunch()
    updatekick()
    if player.punching == false then
     if global.zdown == true then
         player.charging = true
         charge()
     elseif player.charging == true then
         updatecharge()
     end
     if (global.zup == true and
     player.charging == true) then
         player.charging = false
         punch()
     end
     if player.kicking == false then
     if global.zdown == true then
         player.kickcharging = true
         kickcharge()
     elseif player.kickcharging == true then
         updatekickcharge()
     end
     if (global.zup == true and
     player.kickcharging == true) then
         player.kickcharging = false
         kick()
     end
    end
   end
   
   
    updatehurt()
end
function updatebtnz()
 if global.zup == true then
  global.zup = false
 end
    if (btn(4)) then
        if global.zpressed == false then
            global.zpressed = true
            global.zdown = true
        else
            global.zdown = false
        end
    else
        if global.zpressed == true then
            global.zup = true
            global.zpressed = false
        end
    end
    if (btn(5)) then
        if global.xpressed == false then
            global.xpressed = true
            global.xdown = true
        else
            global.xdown = false
        end
    else
        if global.xpressed == true then
            global.xup = true
            global.xpressed = false
        end
    end
end

function anim(o,sf,nf,sp,fl)
  if(not o.a_ct) o.a_ct=0
  if(not o.a_st) o.a_st=0

  o.a_ct+=1

  if(o.a_ct%(30/sp)==0) then
    o.a_st+=1
    if(o.a_st==nf) o.a_st=0
  end

  o.a_fr=sf+o.a_st
  spr(o.a_fr,o.x,o.y,1,2,fl)
end
-->8
function _draw()
    cls()
    map(0,0,0,0,16,16)
    if not global.start then
     
    end
    drawplayer()
   
    if global.shaketimer > 0 then
     camera(cos(global.shaketimer/3),
         cos(global.shaketimer/2))
     global.shaketimer -= 1
 else
     camera(0,0)
 end
end


function drawplayer()

			for p in all (players) do
			draw_one(p)
			end
			
    if player.isdead then
        player.sprite = 138 - player.deadtimer
        if player.deadtimer > 0 then
            player.deadtimer -= 1
            global.resettimer = 100
        end
        if player.deadtimer == 0 then
            global.resettimer -= 1
            fade_scr((100-global.resettimer)/100)
            if global.resettimer == 0 then
                _init()
            end
        end
    end
    spr(player.sprite,
        player.x,
        player.y,
        1,2,player.facingleft)
        
        spr(player2.sprite,
        player2.x,
        player2.y,
        1,2,player2.facingleft)
end

function drawui()
    local lifespr = 16
    for i=1,3 do
        if (i>player.life) then
            lifespr = 17
        else lifespr = 16
        end 
        spr(lifespr, (8*i)+2,3)
    end
end






function punched(o,v)
    player.punchspeed = 1
    o.ispunched = true
    o.punchedtimer = 12
    o.speed = v
    if v > 0 then o.facingleft = false
    elseif v < 0 then o.facingleft = true end
    o.movetimer = 0 // stop random movement
   
 global.shaketimer = 5
end

function kicked(o,v)
    player.kickspeed = 1
    o.iskicked = true
    o.kickedtimer = 12
    o.speed = v
    if v > 0 then o.facingleft = false
    elseif v < 0 then o.facingleft = true end
    o.movetimer = 0 // stop random movement
   
 global.shaketimer = 5
end


function updatepunched(o)
    if o.punchedtimer == 0 then
        o.ispunched = false
        o.speed = 0
        return
    end
    movex(o,o.speed)
    o.punchedtimer -= 1
end

function updatekicked(o)
    if o.kickedtimer == 0 then
        o.iskicked = false
        o.speed = 0
        return
    end
    movex(o,o.speed)
    o.kickedtimer -= 1
end

function init_one()
cls()
			create_players(n_players)
			end
			
function update_one(p)
		if btn(6,p.num-1) then
			p.pos[2]-=1
		elseif btn(7,p.num-1) then
			p.pos[2]+=1
		end
	end	

			
function draw_one(p)

		local x = p.pos[1]
		local y = p.pos[2]
		end
		
		
function create_players(n)

		players = {}
		for i=1,n do
				p = {}
				p.num = i
				p.pos = {start_pos[i], 64}
				add(players,p)
				end
end



-->8
 // collisions
function cmap(o)
    local x1=o.x/8
    local y1=o.y/8
    local x2=(o.x+7)/8
    local y2=(o.y+7)/8
    local a=fget(mget(x1,y1),0)
    local b=fget(mget(x1,y2),0)
    local c=fget(mget(x2,y2),0)
    local d=fget(mget(x2,y1),0)   
   
    local collisions = {}
    collisions.l = a and b
    collisions.r = c and d
    collisions.t = a and d
    collisions.b = b and c
   
    return collisions
end


 


function cobjects(o1,o2)
    return not (o2.x > (o1.x+7) or
                                     (o2.x+7) < o1.x or
                                     o2.y > (o1.y+7) or
                                     (o2.y+7) < o1.y)
end
-->8
-- "fa" is a number ranging from 0 to 1
-- 1 = 100% faded out
-- 0 = 0% faded out
-- 0.5 = 50% faded out, etc.

function fade_scr(fa)
    fa=max(min(1,fa),0)
    local fn=8
    local pn=15
    local fc=1/fn
    local fi=flr(fa/fc)+1
    local fades={
        {1,1,1,1,0,0,0,0},
        {2,2,2,1,1,0,0,0},
        {3,3,4,5,2,1,1,0},
        {4,4,2,2,1,1,1,0},
        {5,5,2,2,1,1,1,0},
        {6,6,13,5,2,1,1,0},
        {7,7,6,13,5,2,1,0},
        {8,9,4,5,2,1,1,0},
        {9,9,4,5,2,1,1,0},
        {10,15,9,4,5,2,1,0},
        {11,11,3,4,5,2,1,0},
        {12,12,13,5,5,2,1,0},
        {13,13,5,5,2,1,1,0},
        {14,9,9,4,5,2,1,0},
        {15,14,9,4,5,2,1,0}
    }
   
    for n=1,pn do
        pal(n,fades[n][fi],0)
    end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900009999000099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900009999000099990000999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900009999000099990000999900009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999990099999900999999000999900009999000099990000999900000000000000000000000000000000000000000000000000000000000000000000000000
90999909909999099099990909999990009999000099990000999900000000000000000000000000000000000000000000000000000000000000000000000000
90999909909999099099990990999909099999900099990000999900000000000000000000000000000000000000000000000000000000000000000000000000
90999909909999099099990990999909909999090999999009999999000000000000000000000000000000000000000000000000000000000000000000000000
00999900009999000099990090999909909999099099990990999900000000000000000000000000000000000000000000000000000000000000000000000000
00900900009009000090090000900900909009099090090990900900000000000000000000000000000000000000000000000000000000000000000000000000
00900900009009000090009000900900009009009090090990900999000000000000000000000000000000000000000000000000000000000000000000000000
00900900009009000090009000900900009009000900009000999009000000000000000000000000000000000000000000000000000000000000000000000000
00900900009000900090000909000090090000909000000900009009000000000000000000000000000000000000000000000000000000000000000000000000
00900900009000900090000909000090090000909000000900009009000000000000000000000000000000000000000000000000000000000000000000000000
00900900009000900090000009000090009009000900009000009009000000000000000000000000000000000000000000000000000000000000000000000000
00900900009000000090000009000090009009000900009000009009000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111100001111000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111100001111000011110000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111100001111000011110000111100001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111110011111100111111000111100001111000011110000111100000000000000000000000000000000000000000000000000000000000000000000000000
10111101101111011011110101111110001111000011110000111100000000000000000000000000000000000000000000000000000000000000000000000000
10111101101111011011110110111101011111100011110000111100000000000000000000000000000000000000000000000000000000000000000000000000
10111101101111011011110110111101101111010111111001111111000000000000000000000000000000000000000000000000000000000000000000000000
00111100001111000011110010111101101111011011110110111100000000000000000000000000000000000000000000000000000000000000000000000000
00100100001001000010010000100100101001011010010110100100000000000000000000000000000000000000000000000000000000000000000000000000
00100100001001000010001000100100001001001010010110100111000000000000000000000000000000000000000000000000000000000000000000000000
00100100001001000010001000100100001001000100001000111001000000000000000000000000000000000000000000000000000000000000000000000000
00100100001000100010000101000010010000101000000100001001000000000000000000000000000000000000000000000000000000000000000000000000
00100100001000100010000101000010010000101000000100001001000000000000000000000000000000000000000000000000000000000000000000000000
00100100001000100010000001000010001001000100001000001001000000000000000000000000000000000000000000000000000000000000000000000000
00100100001000000010000001000010001001000100001000001001000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600000c0500e0500c0000e0500c0500e0000c0500e0500c0000e0500c0500e0000c0500e0500c0000e0500c0500e0500c0000e0500c0500e0000c0500e0500c0000e0500c0500e0000c0500e0500c0000e050
001000001315015150161501115013150151501615011150131501515016150111501315015150161501115013150151501615011150131501515016150111501315015150161501115013150151501615011150
001000001935028600313502760027600203500000015350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000800001355014550105000000000000000000000000000000000000000000135001450013500145001350014500135001450013500145001450000000145000000014500135001450014500000001450000000
0010000000000000001c3501d35018350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f0000135500f550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 00024344

