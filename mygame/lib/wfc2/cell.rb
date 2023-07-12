module Wfc2
  class Cell
    attr_reader :x, :y, :available_tiles, :collapsed

    # x: the x coord of this cell in the cell array
    # y: the y coord of this cell in the cell array
    # available_tiles: an array of Tile objects with their rules attached
    def initialize(x, y, available_tiles)
      @available_tiles = available_tiles
      @collapsed = false
      @x = x
      @y = y
    end

    def update
      @collapsed = @available_tiles.size == 1
    end

    def collapse
      @available_tiles = [@available_tiles.sample]
      @collapsed = true
    end

    def neighbors(grid)
      @neighbors ||= {
        up: grid[@x][@y + 1],
        down: grid[@x][@y - 1],
        right: grid[@x + 1][@y],
        left: grid[@x - 1][@y]
      }
    end
  end
end