module Wfc
  class Cell
    attr_accessor :available_tiles
    attr_reader :x, :y, :collapsed, :grid

    # x: the x coord of this cell in the cell array
    # y: the y coord of this cell in the cell array
    # available_tiles: an array of Tile objects with their rules attached
    def initialize(x, y, available_tiles)
      @available_tiles = available_tiles.flatten
      @collapsed = false
      @x = x
      @y = y
    end

    def update
      @collapsed = @available_tiles.size == 1
    end

    def collapse
      return if @available_tiles.nil?

      @available_tiles = [@available_tiles.sample]
      @collapsed = true
    end

    def neighbors(grid)
      return if grid.nil?

      @neighbors ||= begin
        up = grid[@x][@y + 1] if grid[@x] && @y < grid[0].length - 1
        down = grid[@x][@y - 1] if grid[@x] && @y.positive?
        right = grid[@x + 1][@y] if @x < grid.length - 1
        left = grid[@x - 1][@y] if @x.positive?
        { up: up, down: down, right: right, left: left }
      end
    end
  end
end