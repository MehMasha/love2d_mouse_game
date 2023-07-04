require('startup')
gap = 150
walls = {}
Player = {x = 100, y = 300, R = 10, V = 0, width = 50, height = 50}
Speed = 10
Counter = 0
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

function collide(Player, Wall)
    if Player.x + Player.width >= Wall.x 
    and Player.x <= Wall.x + Wall.width 
    and Player.y + Player.height >= Wall.y 
    and Player.y <= Wall.y + Wall.height then
        return true
    end
    return false
end


function create_wall()
    print('create')
    y = math.random(100, 400)
    x = SCREEN_WIDTH
    wall = {}
    top_wall = {}
    top_wall.x = x
    top_wall.y = 0
    top_wall.width = 30
    top_wall.height = y
    wall.top = top_wall
    bot_wall = {}
    bot_wall.x = x
    bot_wall.y = y + gap
    bot_wall.width = 30
    bot_wall.height = SCREEN_HEIGHT - gap - y
    wall.bot = bot_wall
    table.insert(walls, wall)
end


function move_ball(dt)
    if love.keyboard.isDown('space') then
        Player.V = -30
    end
    Player.V = Player.V + G * dt * 10
    Player.y = Player.y + Player.V * dt * 10
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == 'o' then
        game = false
        Speed = 2
        Player.y = 300
        Player.V = 0
        walls = {}
        Counter = 0
        game_over = false
    elseif scancode == 'p' then
        game = true
        game_over = false
        create_wall()
    end
 end


function love.load()
    backLayer1 = love.graphics.newImage("/Layers/sky.png")
    backLayer2 = love.graphics.newImage("/Layers/glacial_mountains.png")
    backLayer3 = love.graphics.newImage("/Layers/clouds_mg_3.png")
    backLayer4 = love.graphics.newImage("/Layers/clouds_mg_2.png")
    backLayer5 = love.graphics.newImage("/Layers/clouds_mg_1.png")
    backLayer1:setFilter("nearest", "nearest")
    backLayer2:setFilter("nearest", "nearest")
    backLayer3:setFilter("nearest", "nearest")
    backLayer4:setFilter("nearest", "nearest")
    backLayer5:setFilter("nearest", "nearest")
    backgrounds = {
        {image=backLayer1, speed=10, x=0, y=0, x1=SCREEN_WIDTH, y1=0},
        {image=backLayer2, speed=15, x=0, y=0, x1=SCREEN_WIDTH, y1=0},
        {image=backLayer3, speed=22, x=0, y=0, x1=SCREEN_WIDTH, y1=0},
        {image=backLayer4, speed=30, x=0, y=0, x1=SCREEN_WIDTH, y1=0},
        {image=backLayer5, speed=40, x=0, y=0, x1=SCREEN_WIDTH, y1=0},
    }
    backgroundScaleX = SCREEN_WIDTH / backLayer1:getWidth()
    backgroundScaleY = SCREEN_HEIGHT / backLayer1:getHeight()
    tick = require 'tick'
    game = false
    game_over = false
    Player.image = love.graphics.newImage("mouse.png")
    Player.scaleX = Player.width / Player.image:getWidth()
    Player.scaleY = Player.height / Player.image:getHeight()
end

function love.update(dt)
    tick.update(dt)
    if not game or game_over then return end
    move_ball(dt)
    for index, value in ipairs(walls) do
        walls[index].top.x = walls[index].top.x - Speed * dt
        walls[index].bot.x = walls[index].bot.x - Speed * dt
    end
    for index, value in ipairs(backgrounds) do
        backgrounds[index].x = backgrounds[index].x - backgrounds[index].speed * dt
        backgrounds[index].x1 = backgrounds[index].x1 - backgrounds[index].speed * dt
        if backgrounds[index].x < -SCREEN_WIDTH then
            backgrounds[index].x = backgrounds[index].x1
            backgrounds[index].x1 = backgrounds[index].x + SCREEN_WIDTH

        end
    end
    Speed = Speed + 5 * dt
    if #walls > 0 then
        if collide(Player, walls[1].top)
        or collide(Player, walls[1].bot) then
            game_over = true
        end
        if collide(Player, {x=0, y=SCREEN_HEIGHT, width=SCREEN_WIDTH, height=30})
        or collide(Player, {x=0, y=-30, width=SCREEN_WIDTH, height=30}) then
            game_over = true
        end



        if walls[#walls].top.x < SCREEN_WIDTH - 300 then
            create_wall()
        end


        if walls[1].top.x < 0 then
            table.remove(walls, 1)
            Counter = Counter + 1
        end
    end

end

function love.draw()
    for index, value in ipairs(backgrounds) do
        love.graphics.draw(value.image, value.x, value.y,
                       0, backgroundScaleX, backgroundScaleY)
        love.graphics.draw(value.image, value.x1, value.y1,
                       0, backgroundScaleX, backgroundScaleY)
    
    end
    love.graphics.draw(Player.image, Player.x, Player.y,
                       0, Player.scaleX, Player.scaleY)
    love.graphics.print(Counter, 100, 100, 0, 3, 3)
    love.graphics.setColor(1, 0.78, 0.15)
    for index, value in ipairs(walls) do
        local top = value.top
        love.graphics.rectangle('fill', top.x, top.y, top.width, top.height)
        local bot = value.bot
        love.graphics.rectangle('fill', bot.x, bot.y, bot.width, bot.height)
    end
    love.graphics.setColor(1, 1, 1)
    if game_over then
        love.graphics.print('GAME OVER', 400, 300, 0, 5, 5)
    end
end
