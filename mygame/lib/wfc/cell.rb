module Wfc
  class Cell
    attr_reader :x, :y, :collapsed, :grid, :tile_probabilities, :available_tiles

    # x: the x coord of this cell in the cell array
    # y: the y coord of this cell in the cell array
    # available_tiles: an array of Tile objects with their rules attached
    def initialize(x, y, available_tiles)
      @available_tiles = available_tiles.flatten
      @collapsed = false
      @x = x
      @y = y
      refresh_tile_probabilities
    end

    def update
      @collapsed = @available_tiles.size == 1
    end

    def collapse
      return if @available_tiles.nil?

      selected_id = @tile_probabilities.max_by { |_, weight| rand ** (1.0 / weight) }.first
      @available_tiles = [@available_tiles.detect { |t| t.identifier == selected_id }]
      @collapsed = true
    end

    def available_tiles=(new)
      @available_tiles = new
      refresh_tile_probabilities
      @available_tiles
    end

    def refresh_tile_probabilities
      probs = @available_tiles.map(&:probability)
      tile_ids = @available_tiles.map(&:identifier)
      @tile_probabilities = tile_ids.zip(probs)
    end

    def entropy
      @available_tiles.length
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