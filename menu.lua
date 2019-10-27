--MAIN MENU
local composer = require( "composer" )
 
local scene = composer.newScene()
 
local function toStory(event)
    composer.gotoScene("scenes.story", {effect = "fade", time = 500})
end
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local background
local But
local title
local storyTitle

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    background = display.newImageRect( "background.png", width*22, height*22 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)

    But = display.newRoundedRect( width/2, 200, width/2, height/16, 3)
    sceneGroup:insert(But)

    storyTitle= display.newText("Story Mode",width/2, 200,native.systemFont)
    storyTitle:setFillColor( 1, 0, 0.5 )
    sceneGroup:insert(storyTitle)

    But:addEventListener( "tap", toStory )
    
    --title = newText "cliff climb"
    
    
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
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