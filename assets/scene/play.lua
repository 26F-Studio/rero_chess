---@type ReroChess.Game
local game

local mode, host

local function send(...) return (host and TCP.S_send or TCP.C_send)(...) end
local function recv() return (host and TCP.S_receive or TCP.C_receive)() end

---@type Zenitha.Scene
local scene = {}

function scene.load()
    mode, host = SCN.args[1], SCN.args[2]
    if mode == 'demo' then
        MSG('info', "（临时地图）左键走路右键掷骰 键盘回车空格 触屏随便点", 5)
        -- game = require 'assets.game'.new(FILE.load('assets/map/lue_first.luaon', '-luaon',
        --     { TEX = TEX, QUAD = QUAD, COLOR = COLOR }))
        game = require 'assets.game'.new(FILE.load('assets/map/z_test_prop.luaon', '-luaon',
            { TEX = TEX, QUAD = QUAD, COLOR = COLOR }))
    elseif mode == 'netgame' then
        game = require 'assets.game'.new(FILE.load('assets/map/net_test.luaon', '-luaon',
            { TEX = TEX, QUAD = QUAD, COLOR = COLOR }))
    end
    BG.set('play')
end

function scene.unload()
    if mode == 'netgame' then
        if host then
            TCP.S_send({ e = 'end' })
        else
            TCP.C_send({ e = 'end' })
        end
    end
end

function scene.mouseMove(x, y, dx, dy)
    if love.mouse.isDown(1) then
        CURSOR.set('move')
        game.cam:move(dx, dy)
    end
end

function scene.wheelMove(dx, dy)
    game.cam:scale(1 + MATH.sign(dy) * .1)
end

function scene.mouseUp(x, y, k)
    if k == 1 then
        CURSOR.set('pointer')
    end
end

local function doAction(act, manual)
    -- Not local turn
    if mode == 'netgame' and manual then
        if game.roundInfo.player ~= NetRoom.selfID + 1 then return end
        send{
            e = 'action',
            act = act,
        }
    end

    if act == 'move' then
        game:step()
    elseif act == 'dice' then
        game:startRound()
    end
end

function scene.mouseClick(x, y, k)
    if game.selectedPlayer == false then
        -- Select player
        x, y = SCR.xOy:transformPoint(x, y)
        x, y = SCR.xOy_m:inverseTransformPoint(x, y)
        x, y = game.cam.transform:inverseTransformPoint(x, y)
        local pList = TABLE.copy(game.players, 0)
        local closest
        for i = #pList, 1, -1 do
            local p = pList[i]
            if p.canBeSelected and MATH.distance(p.x, p.y, x, y) < 40 / game.cam.k then
                if closest then
                    game.cam.x0, game.cam.y0 = (p.x + closest.x) / 2 * -100, (p.y + closest.y) / 2 * -100
                    game.cam:scale(2)
                    return
                else
                    closest = p
                end
            end
        end
        if closest then
            game.selectedPlayer = closest
        end
    else
        doAction(k == 1 and 'move' or 'dice', true)
    end
end

function scene.touchMove(x, y, dx, dy, id)
    local touches = love.touch.getTouches()
    if #touches <= 1 then
        game.cam:move(dx, dy)
    end
end

function scene.touchClick(x, y, id)
    if not game:step() then
        game:startRound()
    end
end

function scene.keyDown(key, isRep)
    if isRep then return true end
    if key == 'return' then
        game:startRound()
    elseif key == 'space' then
        game:step()
    elseif key == 'escape' then
        SCN.go('quit_sure', 'none', 'back')
    end
    return true
end

function scene.update(dt)
    local d = recv()
    if d then
        if d.event == 'client.disconnect' then
            -- send{ e = "quit", id = d.sender }
        else
            local pack = d.data
            if pack.e == 'action' then
                doAction(pack.act, false)
            end
        end
    end
    game:update(dt)
end

function scene.draw()
    game:draw()
    -- GC.replaceTransform(SCR.xOy)
    -- GC.setColor(COLOR.D)
    -- FONT.set(20)
    -- GC.print("P " .. game.roundInfo.player, 20, 100)
    -- GC.print("step " .. tostring(game.roundInfo.step), 20, 120)
    -- GC.print("lock " .. tostring(game.roundInfo.lock), 20, 140)
    -- GC.print("dice state: " .. tostring(game.players[1].dice.animState), 20, 160)
end

scene.widgetList = {
    QuitButton,
}
return scene
