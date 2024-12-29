---@type ReroChess.Game
local game

---@type Zenitha.Scene
local scene={}

function scene.load()
    game=require'assets.game'.new{
        playerData={
            {name='略',startLocation='start1'},
            {name='略略',startLocation='start2'},
            {name='略略略',startLocation='start3'},
        },
        mapData={
            {x=-3,y=-2,label='start1'},
            {dx=1},
            {dx=1},
            {dx=1,prop='teleport',propData='start2'},
            {dx=1,prop='move',propData=2},
            {dx=1,prop='move',propData=-2},
            {dx=1,prop='teleport',propData='start2'},

            {x=-3,y=-0.5,label='start2'},
            {dx=1,prop='teleport',propData='start3'},
            {dx=1,prop='move',propData=2},
            {dx=1,prop='move',propData=3},
            {dx=1,prop='move',propData=1},
            {dx=1,prop='move',propData=-2},
            {dx=1,prop='move',propData=-5},

            {x=-1,y=1,label='start3',prop='text',propData='!!'},
            {dx=1,stop=true},
            {dx=1},
            {dy=1,stop=true},
            {dy=1},
            {dx=-1,stop=true},
            {dx=-1},
            {dy=-1,next='start3',stop=true},
        },
    }
end

function scene.mouseDown(x,y,k)
    if k==1 then
        game:step()
    elseif k==2 then
        game:roll()
    end
end

function scene.mouseUp(x,y,k)
    if k==1 then
        CURSOR.set('pointer')
    end
end

function scene.mouseMove(x,y,dx,dy)
    if love.mouse.isDown(1) then
        CURSOR.set('move')
        game.cam:move(dx,dy)
    end
end

function scene.wheelMove(dx,dy)
    game.cam:scale(1+dy*.1)
end

function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='return' then
        game:roll()
    elseif key=='space' then
        game:step()
    elseif key=='escape' then
        SCN.back()
    end
    return true
end

function scene.update(dt)
    game:update(dt)
end

function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    game:draw()
end

scene.widgetList={
    WIDGET.new{type='button_simp',pos={1,1},x=-80,y=-120,w=120,h=60,text=LANG'game_roll',code=function() game:roll() end},
    WIDGET.new{type='button_simp',pos={1,1},x=-80,y=-50,w=120,h=60,text=LANG'game_back',code=WIDGET.c_backScn()},
}
return scene
