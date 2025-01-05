--------------------------------------------------------------
-- Setup lua & love2d

math.randomseed(os.time())

love.mouse.setVisible(false)

--------------------------------------------------------------
-- Setup Zenitha

require'Zenitha'

ZENITHA.setFirstScene('title')
ZENITHA.setAppName(require'version'.appName)
ZENITHA.setMainLoopSpeed(60)
ZENITHA.setShowFPS(false)

SCR.setSize(1000,600)

STRING.install()

local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate,gc_scale=gc.translate,gc.scale
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth

local button_simp=WIDGET.newClass('button_simp','button')
function button_simp:draw()
    gc_push('transform')
    gc_translate(self._x,self._y)

    gc_scale(1-self._pressTime/self._pressTimeMax*.1+self._hoverTime/self._hoverTimeMax*.062)
    local w,h=self.w,self.h

    -- Background
    gc_setColor(self.fillColor)
    GC.mRect('fill',0,0,w,h,self.cornerR)

    -- Frame
    gc_setLineWidth(self.lineWidth)
    gc_setColor(self.frameColor)
    GC.mRect('line',0,0,w,h,self.cornerR)

    -- Drawable
    if self._image then
        gc_setColor(1,1,1)
        if self.quad then
            WIDGET._alignDrawQ(self,self._image,self.quad)
        else
            WIDGET._alignDraw(self,self._image)
        end
    end
    if self._text then
        gc_setColor(self.textColor)
        WIDGET._alignDraw(self,self._text)
    end
    gc_pop()
end
local button_invis=WIDGET.newClass('button_invis','button')
function button_invis:draw()
    gc_push('transform')
    gc_translate(self._x,self._y)
    gc_scale(1-self._pressTime/self._pressTimeMax*.1+self._hoverTime/self._hoverTimeMax*.062)
    gc_setColor(1,1,1)
    if self._image then
        if self.quad then
            WIDGET._alignDrawQ(self,self._image,self.quad)
        else
            WIDGET._alignDraw(self,self._image)
        end
    end
    gc_pop()
end
WIDGET.setDefaultOption{
    base={
        color='D',
        textColor='D',
        fillColor='D',
        frameColor='D',
        activeColor='D',
        lineWidth=6,
        cornerR=4,
    },
    button={},
    button_simp={
        cornerR=10,
        lineWidth=4,
        fillColor='dL',
    },
    slider={
        frameColor='LD',
        fillColor='lD',
    },
    switch={},
    slider_fill={},
    checkBox={},
    selector={},
    listBox={},
    inputBox={},
}

do -- Image & Texture & Quad

    local chessData={
        {
            name="普通的棋子娘",
            shadeX=0.02,
        },
        {
            name="一只略",
            shadeX=-.005,
            desc="略都让别人写了自己还不写，所以先随便填一行在这里",
            link="https://space.bilibili.com/1344099355",
        },
        {
            name="十七",
            shadeX=0.015,
        },
        {
            name="棠棠猫",
            shadeX=0.013,
        },
        {
            name="关注娘",
            shadeX=0.013,
            desc="关注[填入up主id]谢谢喵",
        },
        {
            name="铅笔略",
            shadeX=0.013,
        },
        {
            name="长相潦草的幽灵",
            shadeR=.3,
            desc="似了",
        },
        {
            name="普通的熊猫人",
            shadeX=0.013,
        },
        {
            name="豚豚",
            shadeX=0.013,
            desc="从星云中降临的豚豚!!!听说有幸运星属性哦（小声）",
            link="https://space.bilibili.com/1758613795",
        },
        {
            name="Pugwit巴哥白",
            shadeX=0.013,
            desc="大概就是一只因为画画穷到吃不起饭买不起衣服，被迫穿塑料袋的狗罢了",
            link="https://space.bilibili.com/5883019",
        },
        {
            name="一般路过苦米",
            shadeX=0.013,
            desc="似乎可以炸掉地球的可怜画画人类",
            link="https://space.bilibili.com/343175801",
        },
        {
            name="机鱼",
            shadeX=0.013,
            desc="略说之后补上",
            link="https://space.bilibili.com/85881762",
        },
        {
            name="Mos",
            shadeX=0.013,
            desc="她似乎在寻找一个合适的话题",
            link="https://space.bilibili.com/481182075",
        },
    }
    local function path(i) return 'assets/texture/'..i end
    TEX=IMG.init({
        bg_anim={
            path('bg_anim/1.png'),
            path('bg_anim/2.png'),
            path('bg_anim/3.png'),
            path('bg_anim/4.png'),
            path('bg_anim/5.png'),
            path('bg_anim/6.png'),
        },
        ui=path('ui.png'),
        world={default=path('game.png')},
        chess=(function()
            local t={}
            for i=1,#chessData do
                local data=chessData[i]
                t[data.name]={
                    base     =path(("chess/$1/base.png"    ):repD(data.name)),
                    normal   =path(("chess/$1/normal.png"  ):repD(data.name)),
                    forward  =path(("chess/$1/forward.png" ):repD(data.name)),
                    backward =path(("chess/$1/backward.png"):repD(data.name)),
                    selected =path(("chess/$1/selected.png"):repD(data.name)),
                    jail     =path(("chess/$1/jail.png"    ):repD(data.name)),
                    shadeX=data.shadeX or 0,
                    shadeY=data.shadeY or .1,
                    shadeR=data.shadeR or .2,
                }
            end
            return t
        end)(),
        item=path('item.png'),
        doodle=path('doodle.png'),

        crash=path('crash.png'),
    },true)

    NULL(TEX.world.default)

    -- Quad generator based on 128x128 grid
    local function q(x,y,w,h) return GC.newQuad(x*128,y*128,(w or 1)*128,(h or w or 1)*128,1536,1536) end
    QUAD={
        ui={
            exit=q(0,0),
            title={
                skin      =q(0,1),
                doodle    =q(0,2),
                gacha     =q(0,3),
                settings  =q(0,4),
                subscribe =q(0,5),
                lue={
                    fumo=q(1,0),
                    squashed=q(1,1),
                    dead=q(1,2),
                    rip={
                        q(1,3.0,  1,.5),
                        q(1,3.5,  1,.5),
                        q(1,4.0,  1,.5),
                        q(1,4.5,  1,.5),
                        q(1,5.0,  1,.5),
                        q(1,5.5,  1,.5),
                    },
                    ghost=q(1,6, .5),
                }
            },
            gacha={
                tile={
                    q(2,0.0,  2,.5),
                    q(2,0.5,  2,.5),
                    q(2,1.0,  2,.5),
                    q(2,1.5,  2,.5),
                },
                dust={
                    q(2.0,2.0, .5),
                    q(2.5,2.0, .5),
                    q(2.0,2.5, .5),
                    q(2.5,2.5, .5),
                    q(2.0,3.0, .5, 1),
                    q(2.5,3.0, .5, 1),
                    q(3.0,2.0,  1),
                },
            },
            doodle={
                button   =q(4,0),
                equipped =q(4,1,  2,2),
            },
        },
        world={
            tile={---@type love.Quad[]
                q(0,0,  2),
                q(0,2,  2),
                q(0,4,  2),
                q(0,6,  2),
                q(0,8,  2),
                q(0,10, 2),
            },
            path     =q(2,3, .5,.25),

            start    =q(2,0,  1,2),
            finish   =q(3,0,  1,2),
            unknown  =q(4,0,  1,2),

            moveB    =q(2.0,2.0, .5),
            moveF    =q(2.0,2.5, .5),
            warn     =q(2.5,2.0, .5),
            question =q(2.5,2.5, .5),
            hospital =q(3.0,  2),
        },
        item={
            firework         =q(0,0),
            knife            =q(0,1),
            balm             =q(0,2),
            pants            =q(0,3),
            combo            =q(0,4),
            mushroom         =q(0,5),
            cat              =q(0,6),
            dice4            =q(0,7),
            gameboy          =q(0,8),
            error            =q(0,9),
            gas_tank         =q(0,10),

            wheelchair_chair =q(10,0,  2,2),
            wheelchair_wheel =q(11,2),
            unfreeze_ice     =q(10,2),
            unfreeze_hua     =q(10,3),
        },
        doodle={
            smile     =q(0,0),
            what      =q(0,1),
            explosion =q(0,2),
            grass     =q(0,3),
            flower    =q(0,4),
            otto      =q(0,5),
            drool     =q(0,6),
            long_tu   =q(0,7),
            ant       =q(0,8),
            cat       =q(0,9),
            poop      =q(0,10),
            cry       =q(0,11),
            heart     =q(1,0),
            happy     =q(1,1),
            banana    =q(1,2),
        },
    }
end

QuitButton=WIDGET.new{type='button_invis',pos={0,0},x=40,y=40,w=60,image=TEX.ui,quad=QUAD.ui.exit,code=WIDGET.c_pressKey'escape'}

FONT.load{
    norm='assets/fonts/codePixelCJK-Regular.ttf',
    symbol='assets/fonts/symbols.otf',
}
FONT.setDefaultFont('norm')
FONT.setDefaultFallback('symbol')

SCN.addSwapStyle('swipe',{
    duration=.5,timeChange=.25,
    draw=function(t)
        t=t*2
        GC.setColor(.6,.6,.6)
        GC.setAlpha(1-math.abs(t-.5))
        t=t*t*(2*t-3)*2+1
        GC.rectangle('fill',0,t*SCR.h,SCR.w,SCR.h)
    end,
})
SCN.setDefaultSwap('swipe')

LANG.add{zh="assets/language/lang_zh.lua"}
LANG.setDefault('zh')

--------------------------------------------------------------
--- Setup Project & Load Assets

---@type ReroChess.I18N
Texts=LANG.set('zh')

CHAR=require'assets.char'
CURSOR=require'assets.cursor'
DATA=require'assets.data'

local timer=love.timer.getTime
local abs,floor,sin,sign=math.abs,math.floor,math.sin,MATH.sign
local bgAnimScale,timeScale,cycleLen
Jump={
    setBPM=function(bpm)
        bgAnimScale=bpm/10
        timeScale=bpm/60*math.pi
        cycleLen=60/bpm
    end,
    bgFrame=function() -- 1~6 1~6 int
        return floor(timer()*bgAnimScale%6+1)
    end,
    smooth=function() -- 0~1~0 float
        return abs(sin(timer()*timeScale))
    end,
    discrete=function(k) -- 0~1 0~1 float
        return (timer()*(k or 1))%cycleLen/cycleLen
    end,
    sudden=function(k) -- 0 1 0 1
        return timer()*(k or 1)/cycleLen%1>.5 and 1 or 0
    end,
    bool=function(k) -- F T F T
        return timer()*(k or 1)/cycleLen%1>.5
    end,
    sin=function(k)
        return sin(timer()*timeScale*(k or 1))
    end,
    swing=function()
        local s=sin(timer()*timeScale)
        return sign(s)*s^2
    end,
    dodge=function(k)
        local s=sin(timer()*timeScale*(k or 1))
        return sign(s)*abs(s)^.5
    end,
    nametag=function(id)
        return sin(timer()+(id or 0))
    end,
}
Jump.setBPM(120)

---@type table<string, love.Shader>
SHADER={}
for _,v in next,love.filesystem.getDirectoryItems('assets/shader') do
    if FILE.isSafe('assets/shader/'..v) then
        local name=v:sub(1,-6)
        local suc,res=pcall(love.graphics.newShader,'assets/shader/'..name..'.hlsl')
        SHADER[name]=suc and res or error("Err in compiling Shader '"..name.."': "..tostring(res))
    end
end
-- Initialize shader parameters
for k,v in next,{
    gaussianBlur={
        {'smpCount',10}, -- min(400 * radius, 40)
        {'radius',0.026},
    },
    darker={{'k',0.4}},
    lighter={{'k',0.2}},
} do for i=1,#v do SHADER[k]:send(unpack(v[i])) end end

for _,v in next,love.filesystem.getDirectoryItems('assets/background') do
    if FILE.isSafe('assets/background/'..v) and v:sub(-3)=='lua' then
        local name=v:sub(1,-5)
        BG.add(name,FILE.load('assets/background/'..v,'-lua'))
    end
end

for _,v in next,love.filesystem.getDirectoryItems('assets/scene') do
    if FILE.isSafe('assets/scene/'..v) then
        local sceneName=v:sub(1,-5)
        SCN.add(sceneName,FILE.load('assets/scene/'..v,'-lua'))
    end
end
