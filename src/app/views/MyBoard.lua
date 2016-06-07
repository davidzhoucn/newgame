
local Levels = import("..data.myLevels")
local Cell   = import("..views.Cell")

local Board = class("Board", function()
    return display.newNode()
end)

local NODE_PADDING   = 100 * GAME_CELL_STAND_SCALE
local NODE_ZORDER    = 0

local COIN_ZORDER    = 1000

function Board:ctor(levelData)
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    math.randomseed(tostring(os.time()):reverse():sub(1,6))

    self.batch = display.newNode()
    self.batch:setPosition(display.cx, display.cy)
    self:addChild(self.batch)

    self.grid = clone(levelData.grid)
    self.rows = levelData.rows
    self.cols = levelData.cols
    self.cells = {}
    self.flipAnimationCount = 0

    if self.cols <= 8 then
            

        local offsetX = -math.floor(NODE_PADDING * self.cols / 2) - NODE_PADDING / 2
        local offsetY = -math.floor(NODE_PADDING * self.rows / 2) - NODE_PADDING / 2
        -- create board, place all cells
        for row = 1, self.rows do
            local y = row * NODE_PADDING + offsetY
            for col = 1, self.cols do
                local x = col * NODE_PADDING + offsetX
                local nodeSprite = display.newSprite("#BoardNode.png", x, y)
                nodeSprite:setScale(GAME_CELL_STAND_SCALE)
                self.batch:addChild(nodeSprite, NODE_ZORDER)

                local node = self.grid[row][col]
                if node ~= Levels.NODE_IS_EMPTY then
                    local cell = Cell.new()
                    cell:setPosition(x, y)
                    cell:setScale(GAME_CELL_STAND_SCALE)
                    cell.row = row
                    cell.col = col
                    self.grid[row][col] = cell
                    self.cells[#self.cells + 1] = cell
                    self.batch:addChild(cell, COIN_ZORDER)
                   
                end
            end
        end
    else
        GAME_CELL_EIGHT_ADD_SCALE = 8.0 / self.cols
        NODE_PADDING = NODE_PADDING * GAME_CELL_EIGHT_ADD_SCALE
        local offsetX = -math.floor(NODE_PADDING * self.cols / 2) - NODE_PADDING / 2
        local offsetY = -math.floor(NODE_PADDING * self.rows / 2) - NODE_PADDING / 2
        GAME_CELL_STAND_SCALE=GAME_CELL_EIGHT_ADD_SCALE * GAME_CELL_STAND_SCALE
        -- create board, place all cells
        for row = 1, self.rows do
            local y = row * NODE_PADDING + offsetY
            for col = 1, self.cols do
                local x = col * NODE_PADDING + offsetX
                local nodeSprite = display.newSprite("#BoardNode.png", x, y)
                nodeSprite:setScale(GAME_CELL_STAND_SCALE)
                self.batch:addChild(nodeSprite, NODE_ZORDER)

                -- local node = self.grid[row][col]
                -- if node ~= Levels.NODE_IS_EMPTY then
                    local cell = Cell.new()
                    cell:setPosition(x, y)
                    cell:setScale(GAME_CELL_STAND_SCALE)
                    cell.row = row
                    cell.col = col
                    self.grid[row][col] = cell
                    self.cells[#self.cells + 1] = cell
                    self.batch:addChild(cell, COIN_ZORDER)
                    
                -- end
            end
        end
        GAME_CELL_EIGHT_ADD_SCALE = 1.0
        GAME_CELL_STAND_SCALE = 0.75 * GAME_CELL_EIGHT_ADD_SCALE
        NODE_PADDING= 100 * 0.75

        
    end

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)
    self:check()
    self:checkAll()
end
-- function Board:check2()
--     local i=1
--     local j=1
--     while i < self.rows-2 do
--         local sum=1
--         while j < self. 
function Board:check()
    local i=1
    local j=1
    while i <=self.rows do
        j=1
        while j <=self.cols do
            local cell =self.grid[i][j]
            local sum = 1
            while j < self.cols and cell.nodeType == self.grid[i][j+1].nodeType do
                cell =self.grid[i][j+1]
                j = j + 1
                sum = sum + 1
            end
            if sum >= 3 then
                print(i,j)
            end
            j = j + 1
        end
        i = i + 1
    end
    i=1
    j=1
    while i <=self.cols do
        j=1
        while j <=self.rows do
            local cell =self.grid[j][i]
            local sum = 1
            while j < self.rows and cell.nodeType == self.grid[j+1][i].nodeType do
                cell =self.grid[j+1][i]
                j = j + 1
                sum = sum + 1
            end
            if sum >= 3 then
                print(j,i)
            end
            j = j + 1
        end
        i = i + 1
    end
end



    
function Board:checkAll()
  
    local i=1
    local j=1
    while i <self.rows-2 do
        j=1
        while j <self.cols-2 do
            local cell =self.grid[i][j]
            local sum = 1
            while j < self.cols-2 and cell.nodeType == self.grid[i+1][j+1].nodeType do
                cell =self.grid[i+1][j+1]
                j = j + 1
                i = i + 1
                sum = sum + 1
            end
            if sum >= 3 then
                print(i,j)
            end
            j = j + 1
        end
        i = i + 1
    end
    i=3
    j=1
    while i <self.cols-2 do
        j=3
        while j <=self.rows-2 do
            local cell =self.grid[j][i]
            local sum = 1
            while j < self.rows-2 and cell.nodeType == self.grid[j+1][i-1].nodeType do
                cell =self.grid[j+1][i-1]
                j = j + 1
                i = i - 1
                sum = sum + 1
            end
            if sum >= 3 then
                print(j,i)
            end
            j = j + 1
        end
        i = i + 1
    end

        -- for i = 1 ,self.cols-2 do
        --     for j = 1,self.rows-2 do
        --     local cell = self.grid[j][i]
        --      local cell_right1 = self.grid[j+1][i + 1]
        --     -- local cell_right1 = self:getCell(cell.row,i + 1)
            
        --      local cell_right2 = self.grid[j+2][i + 2]
        --      if cell.nodeType == cell_right1.nodeType and
        --        cell.nodeType == cell_right2.nodeType
              
        --        then print(j,i)
            
        --      end
        --     end
        -- end
        -- for j = 1 ,self.rows-2 do
        --     for i = 3,self.cols-2 do
        --     local cell = self.grid[j][i]

        --      local cell_above1 = self.grid[j + 1][i - 1]
        --      local cell_above2 = self.grid[j + 2][i - 2]
        --      if cell.nodeType == cell_above1.nodeType and
        --        cell.nodeType == cell_above2.nodeType
        --        then print(j,i)
            
        --      end
        --     end
        -- end
end   
function Board:getCell(row, col)
    if self.grid[row] then
        return self.grid[row][col]
    end
end
function Board:checkLevelCompleted()
    local count = 0
    for _, cell in ipairs(self.cells) do
        if cell.isWhite then count = count + 1 end
    end
    if count == #self.cells then
        -- completed
        self:setTouchEnabled(false)
        self:dispatchEvent({name = "LEVEL_COMPLETED"})
    end
end

function Board:getCoin(row, col)
    if self.grid[row] then
        return self.grid[row][col]
    end
end

function Board:flipCoin(cell, includeNeighbour)
    if not cell or cell == Levels.NODE_IS_EMPTY then return end

    self.flipAnimationCount = self.flipAnimationCount + 1
    cell:flip(function()
        self.flipAnimationCount = self.flipAnimationCount - 1
        self.batch:reorderChild(cell, COIN_ZORDER)
        if self.flipAnimationCount == 0 then
            self:checkLevelCompleted()
        end
    end)
    if includeNeighbour then
        audio.playSound(GAME_SFX.flipCoin)
        self.batch:reorderChild(cell, COIN_ZORDER + 1)
        self:performWithDelay(function()
            self:flipCoin(self:getCoin(cell.row - 1, coin.col))
            self:flipCoin(self:getCoin(cell.row + 1, coin.col))
            self:flipCoin(self:getCoin(cell.row, coin.col - 1))
            self:flipCoin(self:getCoin(cell.row, coin.col + 1))
        end, 0.25)
    end
end

function Board:onTouch(event, x, y)
    if event ~= "began" or self.flipAnimationCount > 0 then return end

    -- local padding = NODE_PADDING / 2
    -- for _, coin in ipairs(self.cells) do
    --     local cx, cy = coin:getPosition()
    --     cx = cx + display.cx
    --     cy = cy + display.cy
    --     if x >= cx - padding
    --         and x <= cx + padding
    --         and y >= cy - padding
    --         and y <= cy + padding then
    --         self:flipCoin(coin, true)
    --         break
    --     end
    -- end
end

function Board:onEnter()
    self:setTouchEnabled(true)
end

function Board:onExit()
    self:removeAllEventListeners()
end

return Board
