---@type Zenitha.Scene
local scene = {}

function scene.load()
end

function scene.mouseDown(x, y, k)
end

function scene.keyDown(key, isRep)
end

function scene.update(dt)
end

function scene.draw()
    GC.setColor(COLOR.D)
    FONT.set(70)
    GC.print("抽卡(良心)页面\n  嗯还没做\n (不用充钱)\n(就 抽着玩)", 260 + 60 * Jump.swing(), 150, -0.1)
end

scene.widgetList = {
    QuitButton,
}
return scene
