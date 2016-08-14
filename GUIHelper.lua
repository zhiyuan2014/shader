local cc = cc

local P = {}

P.LAYER={}
P.TYPE_SEQUENCE = {
    DEFAULT = 0.1
}
P.OUTLINE_SIZE = 3
P.OUTLINE_COLOR_1 = "0x281111"
P.OUTLINE_COLOR_2 = "0xbd5304"
P.ITEM_RARE_RGB = {
    [1]= cc.c3b(0xFF,0xFF,0xFF),
    [2]=cc.c3b(0x71,0xC4,0x4A),
    [3]=cc.c3b(0x4A,0x93,0xC4),
    [4]=cc.c3b(0xA5,0x4A,0xc4),
    [5]=cc.c3b(0xDB,0x46,0x0B),
    [6]=cc.c3b(0xFF,0x00,0x00),
}

P.TEXT_RGB = {
    SKILL = cc.c3b(188,155,119),
}


P.UI_COLOR3B = {
    WHITE = cc.c3b(255,255,255)
    , BLACK = cc.c3b(0,0,0)
    , RED = cc.c3b(255,0,0)
    , GREEN = cc.c3b(0,255,0)
    , YEELOW = cc.c3b(255,169,0)
    , GREY = cc.c3b(64,64,64)
    , GREY_LIGHT = cc.c3b(96,96,96)

    , BLUE = cc.c3b(118,192,255)
    , PINK = cc.c3b(255,118,118)

}

P.UI_COLOR4B = {
    WHITE = cc.c4b(255,255,255,255)
    , BLACK = cc.c4b(0,0,0,255)
    , GREY_MASK = cc.c4b(0,0,0,144)
    , RED = cc.c4b(255,0,0,255)
    , GREEN= cc.c4b(0,255,0,255)
    , YEELOW = cc.c4b(255,169,0, 255)
    , INVISIBLE = cc.c4b(255,255,255,0)
}
P.UI_ANCHOR = {
    CENTER = 1,
    TOP_LEFT = 2,
    TOP_RIGHT = 3,
    BOTTOM_LEFT = 4,
    BOTTOM_RIGHT = 5,
    CENTER_TOP = 6,
    CENTER_LEFT = 7,
    CENTER_RIGHT = 8,
    CENTER_BOTTOM = 9
}

P.UI_ANCHOR_POINT = {
    ZERO = {x=0, y=0},
    CENTER = {x=0.5 , y=0.5},
    TOP_LEFT = {x=0, y=1},
    TOP_RIGHT = {x=1, y=1},
    BOTTOM_LEFT = {x=0, y=0},
    BOTTOM_RIGHT = {x=1, y=0},
    CENTER_TOP = {x=0.5, y=1},
    CENTER_LEFT = {x=0, y=0.5},
    CENTER_RIGHT = {x=1, y=0.5},
    CENTER_BOTTOM = {x=0.5, y=0}
}

P.FONT = {
    SMALL = 18,--Lv...
    MIDDLE = 25,--name...
    LARGE = 30,--top tab
    SUPER = 40,--title
}

P.FONT_NAME_NORMAL = "Arial"
P.FONT_NAME_DEFAULT = "fonts/WenQuanYi Micro Hei Mono.ttf" 

P.FONT_NAME = {
    ARTIST = "map/parts/ui/id-kaihou.ttf"
}

P.TRANSITION_TAG = {
    FRONT = 222222,
    BACK = 333333,
}

P.PROGRAM_KEYS = {
    NONE = "ShaderPositionTextureColor_noMVP",
    GRAY = "gray",
    OUTLINE = "outline",
    VANISH = "Vanish",
    STONE = "Stone",
    POISON = "Poison",
    MIRROR = "Mirror",
    INVISIBLE = "Invisible",
    ICE = "Ice",
    GRAYSCALING = "GrayScaling",
    FROZEN = "Frozen",
    FIRE = "Fire",
    BANISH = "Banish",
    FLASH = "Flash",
    COLOR = "Color",
    HSL = "HSL",
    LIGHT = "Light",
    FILTER = "ColorFilter",
    REDWITHALPHA = "RedWithAlpha",
    RED = "Red",
    GAUSS_BLUR = "GuassBlur", -- 高斯模糊，毛玻璃，模糊化
}


function P.addBackBtnToParent(parent, pos, callBack)
    local sprite1 = ccui.Scale9Sprite:create("testRes/t_close_1.png")
    local sprite2 = ccui.Scale9Sprite:create("testRes/t_close_2.png")

    local button = cc.ControlButton:create(sprite1)
    button:setBackgroundSpriteForState(sprite2, cc.CONTROL_STATE_HIGH_LIGHTED)
    button:registerControlEventHandler(callBack,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

    button:setAdjustBackgroundImage(false)
    button:setPreferredSize(sprite1:getContentSize())

    parent:addChild(button,1000)
    button:setContentSize(sprite1:getContentSize())
    button:setAnchorPoint(P.UI_ANCHOR_POINT.ZERO)
    button:setPosition(pos)

    return button;
end

function P.addBackBtnToParentTopRight(parent, callBack)
    local pos = cc.p(parent:getContentSize().width, parent:getContentSize().height)
    return P.addBackBtnToParent(parent, pos, callBack)

end


---根据param设置获取子UI中心点相对于父UI左下角偏移坐标
--@param offsetX 相对九点锚点中的某点x轴偏移量
--@param offsetY 相对九点锚点中的某点y轴偏移量
--@param uiWidth ui自身width值
--@param uiHeight    ui自身height值
--@param superWidth  将要成为父节点UI的width值
--@param superHeight 将要成为父节点UI的height值
--@param anchor  九点锚点中的某一点［见common.Enum UI_ANCHOR］
--@return x,y   子UI中心点相对于父UI左下角偏移坐标
function P.offsetWithSuperSize(offsetX, offsetY ,uiWidth, uiHeight, superWidth, superHeight, anchor)
    local x = 0
    local y = 0

    --cclog("GUIHelper offsetWithSuperSize %d,%d,%d,%d,%d,%d,%d",offsetX, offsetY, uiWidth, uiHeight, superWidth, superHeight, anchor)

    local switch = {
        [P.UI_ANCHOR.CENTER] = function()
            x = superWidth*.5 + offsetX
            y = superHeight*.5 + offsetY
        end,
        [P.UI_ANCHOR.TOP_LEFT] = function()
            x = uiWidth*.5 + offsetX;
            y = superHeight + offsetY - uiHeight*.5
        end,
        [P.UI_ANCHOR.TOP_RIGHT] = function()
            x = superWidth + offsetX - uiWidth*.5
            y = superHeight + offsetY - uiHeight*.5
        end,
        [P.UI_ANCHOR.BOTTOM_LEFT] = function()
            x = offsetX + uiWidth*.5
            y = offsetY + uiHeight*.5
        end,
        [P.UI_ANCHOR.BOTTOM_RIGHT] = function()
            x = superWidth + offsetX - uiWidth*.5
            y = offsetY + uiHeight*.5
        end,
        [P.UI_ANCHOR.CENTER_TOP] = function()
            x = superWidth*.5 + offsetX;
            y = superHeight + offsetY - uiHeight*.5
        end,
        [P.UI_ANCHOR.CENTER_LEFT] = function()
            x = offsetX + uiWidth*.5;
            y = superHeight*.5 + offsetY;
        end,
        [P.UI_ANCHOR.CENTER_RIGHT] = function()
            x = superWidth + offsetX - uiWidth*.5
            y = superHeight*.5 + offsetY
        end,
        [P.UI_ANCHOR.CENTER_BOTTOM] = function()
            x = superWidth*.5 + offsetX
            y = offsetY + uiHeight*.5
        end
    }

    local f = switch[anchor]
    if(f) then
        f()
    else                -- for case default
        cclog("GUIHelper offset unknow anchor:%d",anchor)
    end

    return cc.p(x,y)
end


---根据param设置获取子UI中心点相对于屏幕左下角偏移坐标
--@param offsetX 相对九点锚点中的某点x轴偏移量
--@param offsetY 相对九点锚点中的某点y轴偏移量
--@param uiWidth ui自身width值
--@param uiHeight    ui自身height值
--@param anchor  九点锚点中的某一点［见common.Enum UI_ANCHOR］
--@return x,y   子UI中心点相对于屏幕左下角偏移坐标
function P.offset(offsetX, offsetY ,uiWidth, uiHeight, anchor)
    local winSize = cc.Director:getInstance():getWinSize();
    local p = P.offsetWithSuperSize(offsetX,offsetY,uiWidth,uiHeight,winSize.width,winSize.height,anchor)
    local x, y = p.x ,p.y

    local visibleSize = cc.Director:getInstance():getVisibleSize()

    if (P.UI_ANCHOR.TOP_LEFT == anchor) or
        (P.UI_ANCHOR.CENTER_TOP == anchor) or
        (P.UI_ANCHOR.TOP_RIGHT == anchor) then
        y = y - (winSize.height - visibleSize.height)*.5
    elseif (P.UI_ANCHOR.BOTTOM_LEFT) or
        (P.UI_ANCHOR.BOTTOM_RIGHT) or
        (P.UI_ANCHOR.CENTER_BOTTOM) then
        y = y + (winSize.height - visibleSize.height)*.5
    end

    return cc.p(x,y)
end

--------------------------------------------------------------------------------
--创建Armature对象
--@param #string dir 资源所在目录
--@param #string resName armature资源名称
--@return Armature#Armature armature
function P.createArmature(dir, resName)
    local configFilePath = dir..resName..".ExportJson"
    if not cc.FileUtils:getInstance():isFileExist(configFilePath) then
        cclog("file not exist " .. configFilePath)
        return nil
    end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(configFilePath)
    local armature = ccs.Armature:create(resName)

    return armature
end

---从rootNode中查找第一个符合tag值的node
--@param #Node rootNode 根节点Node
--@param #int tag Tag
--@return Node#Node node
function P.getNodeByTag(rootNode, tag)
    if rootNode:getTag() == tag then
        return rootNode
    end
    for k, node in ipairs(rootNode:getChildren()) do
        if node ~= nil then
            local childNode = node:getChildByTag(tag)
            if childNode ~= nil then
                return childNode
            end
            childNode = P.getNodeByTag(node,tag)
            if childNode ~= nil then
                return childNode
            end
        end
    end
    return nil
end

---从rootNode中查找第一个符合tag值的node
--@param #Node rootNode 根节点Node
--@param #string name name
--@return #Node node
function P.getNodeByName(rootNode, name)
    if rootNode:getName() == name then
        return rootNode
    end
    for k, node in ipairs(rootNode:getChildren()) do
        if node ~= nil then
            local childNode = node:getChildByName(name)
            if childNode ~= nil then
                return childNode
            end
            childNode = P.getNodeByName(node,name)
            if childNode ~= nil then
                return childNode
            end
        end
    end
    return nil
end



function P.setControlButtonColorForState(btn, color, state)
    if btn == nil then return end

    local sprite = btn:getBackgroundSpriteForState(state)
    if sprite ~= nil then
        sprite:setColor(color)
    end
    btn:settitleColorForState(color,state)
end

--function P.setControlButtonColorForState(btn, color, state)
--    if btn == nil then return end
--
--    local sprite = btn:getBackgroundSpriteForState(state)
--    if sprite ~= nil then
--        sprite:setColor(color)
--    end
--    btn:settitleColorForState(color,state)
--end
--
--function P.resetControlButtonColorForState(btn, color)
--    P.setControlButtonColorForState(btn, color, cc.CONTROL_STATE_NORMAL);
--    P.setControlButtonColorForState(btn, color, cc.CONTROL_STATE_HIGH_LIGHTED);
--    P.setControlButtonColorForState(btn, color, cc.CONTROL_STATE_DISABLED);
--    P.setControlButtonColorForState(btn, color, cc.CONTROL_STATE_SELECTED);
--end

function P.setControlButtonBg(uiButton, path, pathType)
    if uiButton == nil then return end
    if pathType == nil then
        pathType = ccui.TextureResType.localType
    end
    uiButton:loadTextureNormal(path, pathType);
    uiButton:loadTexturePressed(path, pathType);
    uiButton:loadTextureDisabled(path, pathType);
end

function P.segmentIntersectsRect(p1, p2, rect)
    local pa = cc.p(cc.rectGetMinX(rect), cc.rectGetMinY(rect))
    local pb = cc.p(cc.rectGetMaxX(rect), cc.rectGetMinY(rect))
    local pc = cc.p(cc.rectGetMaxX(rect), cc.rectGetMaxY(rect))
    local pd = cc.p(cc.rectGetMinX(rect), cc.rectGetMaxY(rect))

    if cc.pIsSegmentIntersect(p1,p2,pa,pb) then return true end
    if cc.pIsSegmentIntersect(p1,p2,pb,pc) then return true end
    if cc.pIsSegmentIntersect(p1,p2,pc,pd) then return true end
    if cc.pIsSegmentIntersect(p1,p2,pd,pa) then return true end

    return false
end

--------------------------------------------------------------------------------
--@function [parent=#gui.GUIHelper] convertSceneToParallaxNode 把场景转换成视差节点
--@param Scene#Scene scene	场景
--@param #number mainLayerTag	主场景的Tag
--@return ParallaxNode#ParallaxNode 视差节点
function P.convertSceneToParallaxNode(scene, mainLayerTag)
    local layer = scene:getChildByTag(mainLayerTag)
    if not layer then
        cclog("layer not exist,tag by "..mainLayerTag)
        return
    end
    local mainBgLayer = layer:getChildren()[1]
    local mainLayerSize = mainBgLayer:getContentSize()
    local mainWidth = mainLayerSize.width
    local winSize = cc.Director:getInstance():getWinSize()
    local minWidth = winSize.width

    ---@field ParallaxNode#ParallaxNode
    local newNode = cc.ParallaxNode:create()
    newNode:setContentSize(mainLayerSize)
    local children = scene:getChildren()
    for key, var in ipairs(children) do
        local pos = cc.p(var:getPosition())
        local scale = var:getScale()
        local count = var:getChildrenCount()
        if count > 0 then
            ---@type Node
            local child = nil
            for k, v in ipairs(var:getChildren()) do
                v:removeFromParent()
                if child == nil then
                    child = v
                    local width = child:getContentSize().width

                    local rate = 1
                    if width <= minWidth or mainWidth <= minWidth then
                        rate = 0
                    else
                        rate = (width - minWidth)/(mainWidth - minWidth)
                    end
                    if child.setTouchEnabled ~= nil then
                        child:setTouchEnabled(false)
                    end
                    child:setScale(scale)
                    newNode:addChild(child, key, cc.p(rate,0), pos)
                else
                    child:addChild(v)
                end
            end
        end
    end
    return newNode, mainBgLayer
end

--------------------------------------------------------------------------------
--@param Node#Node src
--@param Node#Node dst
function P.copyBaseValueFromNode(src, dst)
    dst:setPosition(cc.p(src:getPosition()))
    dst:setAnchorPoint(src:getAnchorPoint())
    dst:setScale(src:getScaleX(),src:getScaleY())
    dst:setLocalZOrder(src:getLocalZOrder())
    dst:setColor(src:getColor())
    local type = tolua.type(dst)
    if type ~= "cc.Sprite" and type ~= "cc.Image" and type ~= "ccui.ImageView" then -- 这些类复制会有绘画上的问题
        dst:setContentSize(src:getContentSize())
    end
end

--------------------------------------------------------------------------------
--@param Node#Node src
--@param Node#Node dst
--@param #bool appendChild
function P.replaceNode(src, dst, appendChild)
    if appendChild == nil then
        appendChild = true
    end
    local name = src:getName()
    --	dst:setName(name)
    P.copyBaseValueFromNode(src,dst)
    local parent = src:getParent()
    if parent ~= nil then
        parent:addChild(dst)
    end
    if appendChild then
        for k, child in ipairs(src:getChildren()) do
            child:retain()
            child:removeFromParent()
            dst:addChild(child)
            child:release()
        end
    end
    src:removeFromParent()
end

local vertDefaultSource = cc.FileUtils:getInstance():getStringFromFile("shader/defaultVert.vsh")
local testId = 1


--- 为动画添加Shader
--@param Armature#Armature armature
--@param #string programKey
function P.setProgramForArmature(armature, programKey)
    if armature == nil then
        return
    end
    local bones = armature:getBoneDic()
    local p = nil
    for key, bone in pairs(bones) do
        P.setProgramForSprite(bone,programKey)
    end
    return cc.GLProgramCache:getInstance():getGLProgram(programKey)
end

--- 为精灵添加Shader
--@param Sprite#Sprite sprite
--@param #string programKey
function P.setProgramForSprite(sprite, programKey, notCache, ...)
    if sprite == nil then
        return nil
    end
    local cache = cc.GLProgramCache:getInstance()
    local p = nil
    if not notCache then
        p = cache:getGLProgram(programKey)        
    end
    local fileUtils = cc.FileUtils:getInstance()
    if p == nil and programKey then
        if programKey == P.PROGRAM_KEYS.GRAY then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/gray.fsh"))

            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)
            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
        elseif programKey == P.PROGRAM_KEYS.OUTLINE then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/example_outline.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
            status = sprite:getGLProgramState()

            -- local color = cc.Vertex3F(1.0,0.2, 0.3)
            local color = nil
            color = select(1, ...)
            if not color then
                color = cc.Vertex3F(1.0,1, 1)
            end
            local radius = nil
            radius = select(2, ...)
            if not radius then
                radius = 0.001
            end
            local threshold = nil
            threshold = select(3, ...)
            if not threshold then
                threshold = 1.75
            end

            status:setUniformVec3("u_outlineColor", color);
            status:setUniformFloat("u_radius", radius);
            status:setUniformFloat("u_threshold", threshold);


        elseif programKey == P.PROGRAM_KEYS.NONE then
            cache:loadDefaultGLPrograms()
            sprite:setGLProgram(p)
        elseif programKey == P.PROGRAM_KEYS.FLASH then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/Flash.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
            status = sprite:getGLProgramState()
            local tex = cc.Director:getInstance():getTextureCache():addImage("shader/flashLight.png")
            status:setUniformTexture("u_lightTexture", tex)
            status:setUniformFloat("light_offset", 0.5)--offset:[0-0.5]

        elseif programKey == P.PROGRAM_KEYS.COLOR then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/color.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
        elseif programKey == P.PROGRAM_KEYS.HSL then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/hsl.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
            status = sprite:getGLProgramState()

            status:setUniformFloat("u_dH", 0.0)
            status:setUniformFloat("u_dS", 0.0)
            status:setUniformFloat("u_dL", 0.0)
        elseif programKey == P.PROGRAM_KEYS.LIGHT then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/Light.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
            status = sprite:getGLProgramState()

        elseif programKey == P.PROGRAM_KEYS.FILTER then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/colorFilter.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
            status = sprite:getGLProgramState()
            local gradient_line = select(1,...)
            if not gradient_line then
                gradient_line = 0.7
            end
            local gradient_ver = select(2,...)
            if not gradient_ver then
                gradient_ver = 0.1
            end

            if gradient_line and gradient_ver then
                cclog("colorFilter gradient_line:"..gradient_line.." gradient_ver:"..gradient_ver)
                status:setUniformFloat("gradient_line", gradient_line)
                status:setUniformFloat("gradient_ver", gradient_ver)
            end
        elseif programKey == P.PROGRAM_KEYS.RED then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/colorEffect.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
            status = sprite:getGLProgramState()
            -- local red = cc.mat4.new(1.0,0.0,0.0,0.0,
            --     0.0,0.0,0.0,0.0,
            --     0.0,0.0,0.0,0.0,
            --     1.0, 0.0,0.0,1.0)
            -- status:setUniformMat4("colorEffect",red)

            local red = {x=1.0,y=0.0,z=0.0,w=1.0}
            status:setUniformVec4("colorEffect",red)
        elseif programKey == P.PROGRAM_KEYS.REDWITHALPHA then
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/colorEffect.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
            status = sprite:getGLProgramState()

            -- local red = cc.mat4.new(1.0,0.0,0.0,1.1,
            --     0.0,0.0,0.0,0.0,
            --     0.0,0.0,0.0,0.0,
            --     1.0, 0.0,0.0,1.0)
            local red = {x=1.0,y=0.0,z=0.0,w=0.8}
            -- status:setUniformMat4("colorEffect",red)
            status:setUniformVec4("colorEffect",red)
        elseif programKey == P.PROGRAM_KEYS.GAUSS_BLUR then
            p = P.gaussBlur(sprite, ...)
        else
            p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fileUtils:getStringFromFile("shader/".. programKey .."Shader.fsh"))
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)
            local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
            sprite:setGLProgramState(status)
        end
        if p ~= nil and not notCache then
            cache:addGLProgram(p,programKey)
        end
    else
        sprite:setGLProgram(p)
    end
    return p
end

function P.gaussBlur(sprite, radius, stepNum)
    if not radius then
        radius = 11
    end

    if not stepNum then
        stepNum = 7
    end

    local size = sprite:getContentSize()

    local fileUtils = cc.FileUtils:getInstance()
    local vertDefaultSource = fileUtils:getStringFromFile("shader/defaultVert.vsh")
    local fragSource = fileUtils:getStringFromFile("shader/example_Blur.fsh")
    local p = cc.GLProgram:createWithByteArrays(vertDefaultSource, fragSource)
    p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    p:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
    p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)

    local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
    sprite:setGLProgramState(status)
    status = sprite:getGLProgramState()

    status:setUniformVec2("resolution", {x=size.width,y=size.height})
    status:setUniformFloat("blurRadius", radius)
    status:setUniformFloat("sampleNum", stepNum)

    return p
end

---
-- @param #string maskPath
-- @param #string iconPath
-- @param #string upPath
-- @return Sprite#Sprite
function P.createMaskSpritByPath(maskPath, iconPath, upPath)
    local texture = P.createMaskTextureByPath(maskPath,iconPath,upPath)
    if texture then
        local result = cc.Sprite:createWithTexture(texture)
        return result
    end
    return nil
end

function P.createMaskTextureByPath(maskPath, iconPath, upPath)
    local mask = cc.Sprite:create(maskPath)
    local icon = cc.Sprite:create(iconPath)
    local up = nil
    if upPath ~= nil then
        up = cc.Sprite:create(upPath)
    end
    return P.createMaskTexture(mask, icon, up)
end

function P.createMaskTexture(mask, icon, up)
    if mask == nil or icon == nil then return nil end

    local w = mask:getContentSize().width
    local h = mask:getContentSize().height

    mask:setPosition(cc.p(w/2, h/2))
    mask:setBlendFunc(gl.ONE,gl.ZERO)
    mask:setFlippedY(true)

    icon:setPosition(cc.p(w/2, h/2))
    icon:setBlendFunc(gl.DST_ALPHA,gl.ZERO)
    icon:setFlippedY(true)

    if up ~= nil then
        up:setPosition(cc.p(w/2, h/2))
        up:setFlippedY(true)
    end

    local sprite = cc.RenderTexture:create(w,h)
    sprite:begin()
    mask:visit()
    icon:visit()
    -- if up ~= nil then
    --     up:visit()
    -- end
    sprite["end"](sprite)

    local texture = sprite:getSprite():getTexture()
    return texture
end

function P.addTTFLabelInScrollView(scrollView, size, textColor, space)
    local scrollViewSize = scrollView:getContentSize()
    if space == nil then
        space = 0
    end
    local label = P.addTTFLabel(scrollViewSize.width - space * 2,size,textColor)
    label:setColor(textColor)
    label:setAnchorPoint(0, 1)
    scrollView:addChild(label)
    label:setPositionX(space)

    return label
end

function P.addTTFLabel(width, size, textColor, fontName)
    if fontName == nil then
        fontName = P.FONT_NAME_DEFAULT
    end
    local label = P.createWithTTF("", fontName,size)
    textColor.a = 255
    label:setTextColor(textColor)
    label:setMaxLineWidth(width)
    label:setLineBreakWithoutSpace(true)
    return label
end

function P.replaceLabelByTTFLabel(label)
    if label == nil then
        return nil
    end

    local size = label:getContentSize()
    local labelWidth = size.width
    local color = label:getColor()
    local fontSize = label:getFontSize()
    local fontName = label:getFontName()
--    local fontName = P.FONT_NAME.ARTIST
    local ttfLabel = P.addTTFLabel(labelWidth,fontSize, color, fontName)
    ttfLabel:setAnchorPoint(label:getAnchorPoint())
    ttfLabel:setPosition(label:getPosition())
    ttfLabel:setLocalZOrder(label:getLocalZOrder())
    label:getParent():addChild(ttfLabel)
    label:removeFromParent()

    return ttfLabel
end


---------------------------
-- 目前，被替换的label锚点需要是(1,0.5)，请扩展吧 =.=
--@param
--@return
function P.replaceLabelByFloatLabel(label)
    if label == nil then
        return nil
    end

    local FloatLabel = require("gui.share.FloatLabel")
    local color = label:getColor()
    local fontName = "map/parts/ui/sf6.fnt"
    local anchorPoint = label:getAnchorPoint()
    local newLabel = FloatLabel.new(fontName, anchorPoint, color)
    newLabel:setPosition(label:getPosition())
    label:getParent():addChild(newLabel)
    label:removeFromParent()

    return newLabel
end

function P.updateTTFLabelInScrollView(scrollView, label, str)
    label:setString(str)
    local size = label:getContentSize()
    local scrollViewSize = scrollView:getContentSize()
    size.height = math.max(scrollViewSize.height, size.height)
    label:setAnchorPoint(label:getAnchorPoint().x,1)
    label:setPosition(label:getPositionX(), size.height)
    scrollView:setInnerContainerSize(size)
end

function P.stopAllNodeInNode(node)
    if node == nil then
        return
    end

    node:pause()
    for k,v in pairs(node:getChildren()) do
        P.stopAllNodeInNode(v)
    end
end

function P.resumeAllNodeInNode(node)
    if node == nil then
        return
    end

    node:resume()
    for k,v in pairs(node:getChildren()) do
        P.resumeAllNodeInNode(v)
    end
end

---创建ui主界面
--根据winsize自动修改ui的contentsize,以达到适配效果
--@param string#string path ui的json文件路径
--@param table#table parentNode ui所依赖的父节点
function P.createMainPanelByJson(path, parentNode)
    local widget = ccs.GUIReader:getInstance():widgetFromJsonFile(path)
    if widget then
        local winSize = cc.Director:getInstance():getWinSize()
        widget:setContentSize(winSize)
        parentNode:addChild(widget)
    else
        cclog("createMainPanel failed, Json = "..path)
    end
    return widget
end

--- 生成一个4bColor用一组16进制的数
-- @param string # value 16进制字符串
function P.create4BColor(value)
    local str1 = string.sub(value,3,4)
    local str2 = string.sub(value,5,6)
    local str3 = string.sub(value,7,8)

    return cc.c4b(tonumber(str1, 16),tonumber(str2, 16),tonumber(str3, 16), 255)
end

--- 生成一个3bColor用一组16进制的数
-- @param string # value 16进制字符串
function P.create3BColor(value)
    local str1 = string.sub(value,3,4)
    local str2 = string.sub(value,5,6)
    local str3 = string.sub(value,7,8)    
    
    return cc.c3b(tonumber(str1, 16), tonumber(str2, 16), tonumber(str3, 16))
end

function P.updateImageViewBy(imageView, fileName, texType)
    if fileName == nil or imageView == nil then
        cclog("updateImageViewBy: fileName == nil or imageView == nil")
        return
    end

    local scaleX = imageView:getScaleY()
    local scaleY = imageView:getScaleY()

    imageView:ignoreContentAdaptWithSize(false)
    if texType then
        imageView:loadTexture(fileName, texType)
    else
        imageView:loadTexture(fileName)
    end
    
    imageView:setScale(scaleX, scaleY)
end

function P.repeatScale(node, scaleTo, dur)
    if scaleTo == nil then scaleTo = 0.8 end
    if dur == nil then dur = 0.6 end
    local scaleAct = cc.ScaleBy:create(dur, scaleTo)
    local revAct = scaleAct:reverse()
    local action = cc.RepeatForever:create(cc.Sequence:create(scaleAct, revAct))
    node:runAction(action)
end

function P.repeatFade(node, alphaTo, dur)
    if alphaTo == nil then alphaTo = 0 end
    if dur == nil then dur = 0.6 end
    node:setOpacity(255)
    local fadeAct = cc.FadeTo:create(dur, alphaTo)
    local revAct = cc.FadeTo:create(dur, 255)
    local action = cc.RepeatForever:create(cc.Sequence:create(fadeAct, revAct))
    node:runAction(action)

end

function P.repeatShow(node, dur, flag)
    if dur == nil then dur = 0.6 end
    
    local show = cc.Show:create()
    local hide = cc.Hide:create()
    
    local action = nil
    if flag then
        action = cc.RepeatForever:create(cc.Sequence:create(show, cc.DelayTime:create(dur), hide, cc.DelayTime:create(dur)))
    else
        action = cc.RepeatForever:create(cc.Sequence:create(hide, cc.DelayTime:create(dur), show, cc.DelayTime:create(dur)))    
    end
    node:runAction(action)
end

--------------------------------------
--获取按键的全屏位置，中心点
--
function P.getWorldSpacePoint(widget)
    if widget == nil or widget:getParent() == nil then
        cclog("wight == nil or wight:getParent() == nil")
        return nil
    end

    local size = widget:getContentSize()
        
    local worldCharPos = widget:convertToWorldSpace(cc.p(0,0))
    
    worldCharPos.x = worldCharPos.x + size.width*0.5
    worldCharPos.y = worldCharPos.y + size.height*0.5
    
    return worldCharPos
end

function P.doTransitionAni(curNode, nextNode, duration)
    if curNode == nil or nextNode == nil then
    	return
    end
    if duration < 0 then
    	duration = 0
    end
    curNode:setVisible(true)
    nextNode:setVisible(true)
    local mgr = curNode:getActionManager()
    mgr:removeActionByTag(P.TRANSITION_TAG.FRONT, curNode)
    mgr:removeActionByTag(P.TRANSITION_TAG.BACK, curNode)
    mgr:removeActionByTag(P.TRANSITION_TAG.FRONT, nextNode)
    mgr:removeActionByTag(P.TRANSITION_TAG.BACK, nextNode)

    local scaleTo = cc.ScaleTo:create(duration,0,0.9) 
    local sequence = cc.Sequence:create(scaleTo, cc.Hide:create())
    sequence:setTag(P.TRANSITION_TAG.BACK)
    curNode:runAction(sequence)
    
    nextNode:setScaleX(0)
    nextNode:setScaleY(0.9)
    sequence = cc.Sequence:create(cc.DelayTime:create(duration),cc.ScaleTo:create(duration, 1, 1))
    sequence:setTag(P.TRANSITION_TAG.FRONT)
    nextNode:runAction(sequence)
end

-----------------------------------------
-- 设置node透明度级联
-- 不设置则与透明度相关的动画不起作用
function P.setCascadeOpacity(node)
    if node == nil then
    	return
    end
    node:setCascadeOpacityEnabled(true)
    local children = node:getChildren()
    for key, var in ipairs(children) do
        P.setCascadeOpacity(var)        
    end
end

function P.setChildrenCascadeOpacity(node)
    if node == nil then
        return
    end
    for key, var in ipairs(node:getChildren()) do
        var:setCascadeOpacityEnabled(false)
    end
end

-----------------------------------------------
-- widget 要移动的控件
-- aniTime 动画持续时间
-- delayTime 动画延迟执行时间
-- dir 移动方向，1：表示从左边移入， 2：表示从上边移入，3：表示从右边移入，4：表示从下边移入
-- endPoint nil表示控件当前位置为终点，起始点由dir决定，不为nil则表示以控件当前位置为起点，endPoint为终点
-- callFun 动画完成回调，可以为空
function P.createEnterAni(widget, aniTime, delayTime, dir, endPoint, callFun)
    local x, y
    if endPoint == nil then
        x, y = widget:getPosition()
        local winSize = cc.Director:getInstance():getWinSize()
        local worldCharPos = widget:convertToWorldSpace(cc.p(0,0))
        local deltaX = worldCharPos.x
        local deltaY = worldCharPos.y          

        if dir == 1 then
            widget:setPositionX(x-deltaX-widget:getContentSize().width)
        elseif dir == 2 then
            widget:setPositionY(y+winSize.height-deltaY)
        elseif dir == 3 then
            widget:setPositionX(x+winSize.width-deltaX)
        elseif dir == 4 then    
            widget:setPositionY(y-deltaY-widget:getContentSize().height)
        end    
    else
        x = endPoint.x
        y = endPoint.y
    end

    local moveTo = cc.MoveTo:create(aniTime, cc.p(x, y))
    moveTo = cc.EaseBounceOut:create(moveTo)
    local action = nil
    if callFun then
        if delayTime > 0 then
            action = cc.Sequence:create(cc.DelayTime:create(delayTime), moveTo, cc.CallFunc:create(function()
                callFun()
            end))
        else 
            action = cc.Sequence:create(moveTo, cc.CallFunc:create(function()
                callFun()
            end))                	
        end
    else
        if delayTime > 0 then
            action = cc.Sequence:create(cc.DelayTime:create(delayTime), moveTo)
        else
            action = moveTo                	
        end
    end
    
    widget:runAction(action)
end


-----------------------------------------------
-- widget 要移动的控件
-- aniTime 动画持续时间
-- delayTime 动画延迟执行时间
-- dir 移动方向，1：表示从左边移入， 2：表示从上边移入，3：表示从右边移入，4：表示从下边移入
-- callFun 动画完成回调，可以为空
function P.createQuitAni(widget, aniTime, delayTime, dir, callFun, easeBounce)
    local x, y = widget:getPosition()
    local winSize = cc.Director:getInstance():getWinSize()
    local worldCharPos = widget:convertToWorldSpace(cc.p(0,0))
    local deltaX = worldCharPos.x
    local deltaY = worldCharPos.y          

    if dir == 1 then
        x = x-deltaX-widget:getContentSize().width
    elseif dir == 2 then
        y = y+winSize.height-deltaY
    elseif dir == 3 then
        x = x+winSize.width-deltaX
    elseif dir == 4 then    
        y = y-deltaY-widget:getContentSize().height
    end    

    local moveTo = cc.MoveTo:create(aniTime, cc.p(x, y))
    if easeBounce then
        moveTo = cc.EaseBounceIn:create(moveTo)
    end
    local action = nil
    if callFun then
        if delayTime > 0 then
            action = cc.Sequence:create(cc.DelayTime:create(delayTime), moveTo, cc.CallFunc:create(function()
                callFun()
            end))
        else
            action = cc.Sequence:create(moveTo, cc.CallFunc:create(function()
                callFun()
            end))                	
        end
    else
        if delayTime > 0 then
            action = cc.Sequence:create(cc.DelayTime:create(delayTime), moveTo)
        else
            action = moveTo
        end
    end

    widget:runAction(action)
end
-----------------------------------------------
-- widget 要移动缩小的layer
-- aniTime 动画持续时间
-- centerWidget 缩小的中心控件，以该控件中心作为缩放中心
-- callFun 动画完成回调，可以为空
function P.createScaleQuitAni(widget, aniTime, centerWidget, callFun)
    local winSize = cc.Director:getInstance():getWinSize()
    local worldCharPos = centerWidget:convertToWorldSpace(cc.p(centerWidget:getContentSize().width,centerWidget:getContentSize().height))
    local imageView = centerWidget:clone()
    local parent = cc.Director:getInstance():getRunningScene()
    imageView:setPosition(worldCharPos)
    parent:addChild(imageView, widget:getZOrder()+100)
    centerWidget:setVisible(false)

    local anchorPointX = worldCharPos.x / winSize.width
    local anchorPointY = worldCharPos.y / winSize.height
    widget:setAnchorPoint(anchorPointX, anchorPointY)
    
    local scaleTo = cc.ScaleTo:create(aniTime, 0.1)
    local fadeOut = cc.FadeOut:create(0.1)
    local spawn = cc.Spawn:create(scaleTo, fadeOut)
    local action = nil
    action = cc.Sequence:create(spawn, cc.CallFunc:create(function()
        imageView:removeFromParent()
         if callFun then
            callFun()         	
         end
    end))

    widget:runAction(action)
end

function P.getColorOfNumber(number)
    local num = tonumber(number)
    if num >= 0 then
    	return P.UI_COLOR3B.YEELOW
    end
    return P.UI_COLOR3B.RED
end

function P.createRenderTexture(node)
    if node == nil then return nil end

    local w = node:getContentSize().width
    local h = node:getContentSize().height

    local render = cc.RenderTexture:create(w,h)
    render:begin()
    node:visit()
    -- if up ~= nil then
    --     up:visit()
    -- end
    render["end"](render)
    
    local spr = cc.Sprite:createWithTexture(render:getSprite():getTexture())
    spr:setFlippedY(true)

    return spr
end

---返回由scene生成的高斯模糊图片
function P.createSceneBackground(node)
    node:setVisible(false)
    local bgSpr = P.createRenderTexture(cc.Director:getInstance():getRunningScene())
    P.setProgramForSprite(bgSpr,P.PROGRAM_KEYS.GAUSS_BLUR,true,7,8)
    bgSpr:setAnchorPoint(0,0)

    node:addChild(bgSpr,-1)

    node:setVisible(true)

    return bgSpr
end   

function P.doShake(node,factor)
    if not factor then
        factor = 1.0
    end
    local a1 = cc.MoveBy:create(0.05,cc.p(0,4*factor))
    local a2 = cc.MoveBy:create(0.05,cc.p(0,-4*factor))    
    local a3 = cc.MoveBy:create(0.05,cc.p(-4*factor,0))
    local a4 = cc.MoveBy:create(0.05,cc.p(4*factor,0))    
    local a5 = cc.MoveBy:create(0.05,cc.p(2*factor,0))
    local a6 = cc.MoveBy:create(0.05,cc.p(-2*factor,0))

    if node ~= nil then
        node:runAction(cc.Sequence:create(a1,a2,a3,a4,a5,a6))
    end

end

local Helper = ccui.Helper
local LKString = require("core.common.LKString")
function P.setLabelString(parent, labelName, key)
    local label = Helper:seekWidgetByName(parent, labelName)
    label:setString(LKString.getString(key)) 
    return label
end

function P.createWithTTF(text, fontName,fontSize)
    cclog("fontName="..fontName)
    if fontName and LKString.getLanguage() == LKString.CN then
        local CcConfig = require("conf.CcConfig")
        -- 如果是简体版，降黑钢和怀仿字体改为简体字体
        local pattern = string.gsub(CcConfig.FONT_NAME.HEI_GANG,"[%-%.]","%%%1") -- 转义
        fontName = string.gsub(fontName, pattern,CcConfig.FONT_NAME.JIAN_TI)
        cclog("replace:"..fontName)

        pattern = string.gsub(CcConfig.FONT_NAME.HUAI_FANG,"[%-%.]","%%%1") -- 转义
        fontName = string.gsub(fontName, pattern,CcConfig.FONT_NAME.JIAN_TI)            
        cclog("replace:"..fontName)
    end
    return cc.Label:createWithTTF(text, fontName,fontSize)
end


function P.showToast(node)
    if not node then
        return
    end
        
    local scene = cc.Director:getInstance():getRunningScene()
    local winSize = cc.Director:getInstance():getWinSize()
    scene:addChild(node,10000)
	node:setAnchorPoint(cc.p(0.5,0.5))
	node:setPosition(cc.p(winSize.width/2,winSize.height/2))
	P.setCascadeOpacity(node)
	
	local aniTime = 1.5
	node:setScale(0.2)
	local scaleTo1 = cc.ScaleTo:create(0.5, 1.2)
    local scaleTo2 = cc.ScaleTo:create(0.5, 1.0)
    	
	local fadeOut = cc.FadeOut:create(aniTime)
	local moveBy = cc.MoveBy:create(aniTime,cc.p(0, 100))
    local spawn = cc.Spawn:create(fadeOut,moveBy)
    local action = cc.Sequence:create(scaleTo1, scaleTo2, cc.DelayTime:create(0.5), spawn, cc.RemoveSelf:create())

    node:runAction(action)
end

function P.typeLabel(label, time, callBack, from)
    label:setVisible(true)
    local str = label:getString()
    local len = label:getStringLength() + label:getStringNumLines()
    if from == nil then
        from = 0
    end
    cclog("len=="..len) 

    local last = 0
    for i=from,len-1 do
        local sprite = label:getLetter(i)
        if sprite then
            sprite:setScale(0)
            sprite:setVisible(false)
        else
            if last == 0 then
                last = i-1
            end
            cclog("sprite is nil ".. i)
        end
    end

    for i=from,len-1 do
        local sprite = label:getLetter(i)
        if sprite then
            sprite:setVisible(true)
            local dt = cc.DelayTime:create((i-from)*time)
            local st = cc.ScaleTo:create(time, 1)
            local funct = nil
            if (i == len - 1 or i == last) and callBack then
                funct = cc.CallFunc:create(callBack)
--                callBack()
            end
            if funct then
                sprite:runAction(cc.Sequence:create(dt,st, funct))
            else
                sprite:runAction(cc.Sequence:create(dt,st))
            end
        end
    end
end
function P.stopTypeLabel(label, callBack)
    local str = label:getString()
    local len = label:getStringLength() + label:getStringNumLines()

    local last = 0
    for i=0,len-1 do
        local sprite = label:getLetter(i)
        if sprite then
            sprite:stopAllActions()
            sprite:setScale(1)
            sprite:setVisible(true)
        end
    end
end

function P.enableOutline(uiText, color3B, outlineSize)
--太卡，不适合刷新
    if true then
        return 
    end
    local tag = 1000000
    local anchor = uiText:getAnchorPoint()
    local size = uiText:getContentSize()
    for x = -1, 1 do
        for y = -1, 1 do
            local child = uiText:getChildByTag(tag)
            if child then
                child:removeFromParent()                
            end
            tag = tag+1
        end
    end
    tag = 1000000
    for x = -1, 1 do
        for y = -1, 1 do
            local child = uiText:clone()
            child:setTag(tag)
            child:setScale(1,1)
            uiText:addChild(child,-1)
            local posX = x*outlineSize + anchor.x*size.width
            local posY = y*outlineSize + anchor.y*size.height
            child:setPosition(cc.p(posX,posY))
            child:setColor(color3B)
            tag = tag+1
        end
    end
end

function P.enableTouch(widget, flag)
    widget:setTouchEnabled(flag)
    for k,v in pairs(widget:getChildren()) do
        v:setTouchEnabled(flag)
    end
end

-------------------------------------
--listView的getInnerContainerSize()无限大所以不能直接用scrollToBottom
--
function P.scrollToBottom(listView, time, delay)    
    if delay == nil then
    	delay = 0
    end
    if time == nil then
    	time = ANI_DURATION
    end
    cclog("=====time = "..time)
    local innerContainer =  listView:getInnerContainer()    
    local delayAction = cc.DelayTime:create(delay)
    local moveAction = cc.MoveTo:create(ANI_DURATION,cc.p(0, 0))
    local action = cc.Sequence:create(delayAction, moveAction)

    innerContainer:runAction(action)
end

---------------------------
--@param
--@return
function P.addItemSpriteFrameCache()
    cclog("GUIHelper.addItemSpriteFrameCache...")
    for index=1, 10 do
    	local fileName = "item/itemicon" .. index .. ".plist"
        local isExist = cc.FileUtils:getInstance():isFileExist(fileName)
        if isExist then
            cc.SpriteFrameCache:getInstance():addSpriteFrames(fileName)
        end
    end
    
    for index=1, 10 do
        local fileName = "item/Weapon" .. index .. ".plist"
        local isExist = cc.FileUtils:getInstance():isFileExist(fileName)
        if isExist then
            cc.SpriteFrameCache:getInstance():addSpriteFrames(fileName)
        end
    end
end

function P.addSkillSpriteFrameCache()
    cclog("GUIHelper.addSkillSpriteFrameCache...")
    for index=1, 10 do
        local fileName = "skill/skillicon" .. index .. ".plist"
        local isExist = cc.FileUtils:getInstance():isFileExist(fileName)
        if isExist then
            cc.SpriteFrameCache:getInstance():addSpriteFrames(fileName)
        end
    end
end

function P.isAndroidDevice()
    local app = cc.Application:getInstance()
    local target = app:getTargetPlatform()
    if target == cc.PLATFORM_OS_ANDROID then
        return true
    end

    return false
end

function P.isIOSDevice()
    local app = cc.Application:getInstance()
    local target = app:getTargetPlatform()
    if target == cc.PLATFORM_OS_IPHONE or target == cc.PLATFORM_OS_IPAD then
        return true
    end

    return false
end

function P.setPlayerIcon(icon, iconImage)
    if icon and iconImage then
        local playerId = string.sub(icon, 2)
        local CcConfig = require("conf.CcConfig")
        local TemplateService = require("core.service.TemplateService")
        local player = TemplateService.get("player", tonumber(playerId))
        if player ~= nil then
            cclog("player not fount... playerId=" .. playerId)
            local path = CcConfig.RES_DIR.NPC.getHeadIcon(player.resId)
            P.updateImageViewBy(iconImage, path)            
        end
    end 
end

function P.initDownloadImage(url, parent)    
    if url == nil or parent == nil then
        return false
    end
    
    if cpp_downloadPngWithUrlAndCallBack then
        parent:retain()
        url = string.urldecode(url)
        cclog("111 =========== url:"..url)
        cpp_downloadPngWithUrlAndCallBack(url, 
            function(image, url) 
                cclog("22 =========== url:"..url)
                if image then
                    local tex = cc.Texture2D:new()
                    tex:initWithImage(image)
                    local sprite = cc.Sprite:createWithTexture(tex)
                    sprite:setPosition(0, 0)
                    sprite:setAnchorPoint(0, 0)
                    local scaleX = parent:getContentSize().width/sprite:getContentSize().width
                    local scaleY = parent:getContentSize().height/sprite:getContentSize().height
                    sprite:setScale(scaleX, scaleY)
                    parent:addChild(sprite)
                end
                parent:release()
            end)
            
        return true
    end  
    
    return false          
end


return P
