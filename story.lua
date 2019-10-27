local composer = require( "composer" )
local scene = composer.newScene()

local values = {}
local shakecount = 0
local count = 0.0
local level = 8
OnLevel = 1

local function resetGyro(event)
    count = 0
end
checkside = false

textBox = native.newTextBox( 160, 240, 280, 140 )
textBox.hasBackground = false
textBox:setTextColor( 0.8, 0.8, 0.8 )


--The function that is called when the gyroscope recieves input
local function onGyroscopeDataReceived( event )
    -- Calculate approximate rotation traveled via delta time
    -- Remember that rotation rate is in radians per second
    local deltaRadians = event.yRotation * event.deltaTime
    --prevents garbage collection by limiting the value of the gyro
    if(math.abs(deltaRadians) > 0.001) then
        count = deltaRadians+count
        if( math.abs(count) > math.pi*2) then 
          if(count >1) then count = count - math.pi*2
          else count = count + math.pi*2
           end
        end
        --calculates totale degree of change
    end
    if ((count) <= 1) and ((count) >= -1)then
        --limits motion by 90 degrees on both sides
        local shake = shakecount
        physics.setGravity(math.asin(count)*20, math.acos(count)*20) --changes gravity to tilt
    end
    if OnLevel ~= level then
        if (OnLevel%2) ==1 then 
           if ball.x> width*0.8 then
            physics.addBody(physBodies[OnLevel+1], "static", {bounce = 0.0})
            physics.removeBody(physBodies[OnLevel])
            ball.bodyType = "kinematic"
            transition.to(ball, {x = (ball.x), y=(ball.y-20), time = 20  })
            ball.bodyType = "dynamic"
            OnLevel = OnLevel +1
            end
        else 
            if ball.x< width*0.2 then
                physics.addBody(physBodies[OnLevel+1], "static", {bounce = 0.0})
                physics.removeBody(physBodies[OnLevel])
                ball.bodyType = "kinematic"
                transition.to(ball, {x = (ball.x), y=(ball.y-20), time = 20  })
                ball.bodyType = "dynamic"
                OnLevel = OnLevel +1
            end    
        end 
    end
    if (ball.x > width) or (ball.x < 0) or (ball.y > height) then

        physics.removeBody(physBodies[OnLevel])
        physics.addBody(physBodies[1], "static", {bounce = 0.0})
        ball.x = width*.21
        ball.y = height*0.7
        OnLevel = 1
    end
end


local function offset_xy( t ) -- polygon absolute coordinates.. idk lol

	local table_sort = table.sort
	local coordinatesX, coordinatesY = {}, {}
	local minX, maxX, minY, maxY

	local function compare( a, b )
		return a > b
	end

	for i = 1, #t*0.5 do
		coordinatesY[i] = t[i*2]
	end

	for i = 1, #t*0.5 do
		coordinatesX[i] = t[i*2-1]
	end

	table_sort( coordinatesX, compare )
	maxX = coordinatesX[1]
	minX = coordinatesX[#coordinatesX]

	table_sort( coordinatesY, compare )
	maxY = coordinatesY[1]
	minY = coordinatesY[#coordinatesY]

	local offset_x = (minX+maxX)*0.5
    local offset_y = (minY+maxY)*0.5
    
	return offset_x, offset_y
end


local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5
 
-- Sets up the coordinates to set up the curve of the hill(s)
values = {}
valuesL = {}
index =1
for i=-width*2/5-5, width*2/5+5 do 
    values[index] = i 
    if i >-52 then
        values[index+1] = -(1/40*((i/13+4)^2)) *13
    else 
        values[index+1] = -(1/25*((i/13+4)^2)) *13
    end
	index = index+2
end
values[index] = values[index-2]
values[index+1] = 10
values[index+2] = values[1]
values[index+3] = 10
--Big curve on left
index = 1
for i=-width*2/5-5, width*2/5+5 do 
    valuesL[index] = i
    if i <52 then
        valuesL[index+1] = -(1/40*((-i/13+4)^2)) *13
    else 
        valuesL[index+1] = -(1/25*((-i/13+4)^2)) *13
    end
	index = index+2
end

valuesL[index] = values[index-2]
valuesL[index+1] = 10
valuesL[index+2] = values[1]
valuesL[index+3] = 10
-- finish making both left and right
local offset_x, offset_y = offset_xy(values)
local offset_xL, offset_yL = offset_xy(valuesL)

index = 1
bsd = {} -- visual part of it
for i=-width*2/5-20, width*2/5+20 do 
    bsd[index] = i
    if i >-52 then
        bsd[index+1] = -(1/40*((i/13+5)^2)) *13+10
    else 
        bsd[index+1] = -(1/20*((i/13+5)^2)) *13+10
    end
	index = index+2
end
for i = -77, 30 do
    bsd[index] = bsd[593] - ((i+78)/15)^2
    bsd[index+1] = i
    index = index+2
end
bsd[index] = bsd[1] +48 -- -148
bsd[index+1] = 30
index = index +2
for i = 1,48 do
    bsd[index] = -100-i
    bsd[index+1] = -((i/7.2)^2)+30
    index = index +2
end
-- -148, -16.4961
-- -100, 30
xs, xy = offset_xy(bsd)

-- 3d depth thing on top
path = {}
index = 1
for i = -77, 30 do
    path[index] = bsd[593] + (((i+78)/19)^2) -148*2
    path[index+1] = i -(30+16.4961)
    index = index+2
end
mnb = index-2
for i=-width*2/5-20+33, (width*2/5+20)*0.6 do 
    path[index] = i 
    if i >-52 then
        path[index+1] = -(1/40*((i/13+5)^2)) *13-7
    else 
        path[index+1] = -(1/20*((i/13+5)^2)) *13-7
    end
	index = index+2
end
--index-2 = 88
for i=60, -width*2/5+20, -1 do 
    path[index] = i
    if i <52 then
        path[index+1] = -(1/40*((-i/13+4)^2)) *13-45
    else 
        path[index+1] = -(1/30*((-i/13+4)^2)) *13-45
    end
	index = index+2
end
--------------------------
index = 1
visual3 = {}
for i = -72, 22 do
    visual3[index] = 145 - (((i+78)/19)^2)
    visual3[index+1] = i 
    index = index+2
end
for i= 115.612, -width*2/5+5 +50, -1 do 
    visual3[index] = i
    if i <52 then
        visual3[index+1] = -(1/40*((-i/13+4)^2)) *13 + 35
    else 
        visual3[index+1] = -(1/25*((-i/13+4)^2)) *13 + 35
        --25
    end
	index = index+2
end

for i=-72.388, 144 do 
    visual3[index] = i 
    if i >-52 then
        visual3[index+1] = -(1/40*((i/13+4)^2)) *13 +5
    else 
        visual3[index+1] = -(1/25*((i/13+4)^2)) *13 +5
    end
	index = index+2
end
---------------
--line values for level generator
customLineValues = {}
index = 1
for i = 1, 30 do
    if i < 31 then
        customLineValues[index] = 105-1+i
        customLineValues[index +1] = 100+i/8
    end
    index = index+2
end
cLVx, cLVy = offset_xy(customLineValues)


visual3x, visual3y = offset_xy(visual3)
pathx, pathy = offset_xy(path)
lineValues = {bsd[1],bsd[2],path[mnb],path[mnb+1],bsd[1],bsd[2], path[mnb],path[mnb+1]}
linex, liney = offset_xy(lineValues)

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 


physBodies = {}
visualBodies = {}
visualLines = {}
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( "background.png", width*22, height*22 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background) -- sets up the background to be the color blue, eliminates black bars

    sceneGroup:insert(textBox) -- debugging textbox

    firstPlatform = display.newPolygon( halfW, height*0.8, values )
    --o.fill = { type="image", filename="clouds.png" }
    firstPlatform.x = firstPlatform.x+ offset_x
    firstPlatform.y = firstPlatform.y+ offset_y
    firstPlatform.strokeWidth = 1
    firstPlatform.isVisible = false
    physBodies[1] = firstPlatform
    sceneGroup:insert(firstPlatform) -- curve 1

    firstVisualPlatform = display.newPolygon(halfW, height*0.8,bsd)
    firstVisualPlatform.strokeWidth = 1
    firstVisualPlatform.x = firstVisualPlatform.x+xs
    firstVisualPlatform.y = firstVisualPlatform.y+ xy
    firstVisualPlatform:setStrokeColor(0,0,0)
    firstVisualPlatform.strokeWidth = 3
    sceneGroup:insert(firstVisualPlatform)

    line = display.newPolygon(halfW,height*0.8,lineValues)
    line:setStrokeColor(0,0,0)
    line.strokeWidth = 1
    line.x = line.x + linex
    line.y = line.y + liney
    sceneGroup:insert(line)

    if level > 1 then 
        secondPlatform = display.newPolygon( halfW, height*0.69, valuesL )
        secondPlatform.x = secondPlatform.x+ offset_xL
        secondPlatform.y = secondPlatform.y+ offset_yL
        secondPlatform.strokeWidth = 1
        secondPlatform.isVisible = false
        physBodies[2] = secondPlatform
        sceneGroup:insert(secondPlatform) --curve 2

        local secondVisualPlatform = display.newPolygon(halfW,height*0.8, path)
        secondVisualPlatform.x = secondVisualPlatform.x + pathx
        secondVisualPlatform.y = secondVisualPlatform.y +pathy
        secondVisualPlatform:setStrokeColor(0,0,0)
        secondVisualPlatform.strokeWidth = 3
        
        sceneGroup:insert(secondVisualPlatform)

        line2 = display.newPolygon(halfW,height*0.8,lineValues)
        line2:setStrokeColor(0,0,0)
        line2.strokeWidth = 2
        line2.x = line2.x + linex +265
        line2.y = line2.y + liney-62
        sceneGroup:insert(line2)

        thirdline = display.newLine(10, 260, 48, 257)
        thirdline:setStrokeColor(0,0,0)
        thirdline.strokeWidth =2
        sceneGroup:insert(thirdline)

        if level >2 then
            for i = 2, level-1 do
                local object
                if( i%2) == 0  then  
                     object = display.newPolygon( halfW, height*(0.58-(i-2)*0.1), values )
                else  object = display.newPolygon( halfW, height*(0.58-(i-2)*0.1), valuesL )
                end
                object.x = object.x+ offset_xL
                object.y = object.y+ offset_yL
                object:setStrokeColor(0,0,0)
                object.strokeWidth = 1
                object.isVisible = false
                local thing = object
                physBodies[i+1] = thing
                sceneGroup:insert(physBodies[i+1]) --curve 2

                local object2 = display.newPolygon(halfW, height*(0.59-(i-2)*0.1), visual3)
                object2.x = object2.x +visual3x
                object2.y = object2.y + visual3y
                object2:setStrokeColor(0,0,0)
                object2.strokeWidth = 3
                if( i%2) == 1  then 
                    object2.xScale = -1 
                    object2.x = object2.x-70
                end
                visualBodies[i-1] = object2
                sceneGroup:insert(visualBodies[i-1])
                
                if i ~= (level-1) then
                    local object3 = display.newPolygon(width*0.905,height*(0.340-(i-3)*0.1),customLineValues)
                    object3:setStrokeColor(0,0,0)
                    object3.strokeWidth = 2.5
                    if(i%2) == 1 then
                        object3.xScale = -1
                        object3.x = width*0.1
                        object3.y = height*(0.340-(i-3)*0.1)
                    end
                  visualLines[i-1] = object3
                  sceneGroup:insert(visualLines[i-1])
                end
            end 
        end
        
    end


    ball = display.newCircle( 112, 150, 20 )
    ball.x = display.contentCenterX
    ball.alpha = 1.0
    ball.fill.r = {1.0}
    ball:toFront()
    sceneGroup:insert(ball) -- the ball

     reset = display.newCircle( 50, 50, 30) -- resets gyro
    sceneGroup:insert(reset)
end
 
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        composer.removeScene("scenes.menu")
        local physics = require( "physics" )
        physics.start(true)
        physics.setGravity(0, 9.8)

        physics.addBody( ball, "dynamic", { radius=20, bounce=0.2, density = 1.0 } )
        ball.linearDamping = 0.2
        ball.angularDamping = 0.2
        physics.addBody(firstPlatform, "static", {bounce = 0.0})

        Runtime:addEventListener( "gyroscope", onGyroscopeDataReceived )
        reset:addEventListener( "touch", resetGyro )

    end
end
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene




--[[
    q = display.newPolygon( halfW, height*0.59, valuesL )
    q.xScale = -1
    q.x = q.x+ offset_xL
    q.y = q.y+ offset_yL
    q:setStrokeColor(0,0,0)
    q.strokeWidth = 1
    q.isVisible = false
    sceneGroup:insert(q) --curve 2
]] -- STANDARD CURVE^^^^