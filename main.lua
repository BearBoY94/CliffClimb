local composer = require( "composer" )

system.setGyroscopeInterval( 100 )
height = display.contentHeight
width = display.contentWidth

local path = system.pathForFile( "data.dat", system.DocumentsDirectory )
local check = io.open( path, "r" )


if check then
   --> File Found

else
   --> File not found
    -- Write data to file
    check = io.open(path, "w")
    check:write("1")
    -- Close the file handle
    io.close( check )
    -- RUN TUTORIAL

end

composer.gotoScene("scenes.story")


