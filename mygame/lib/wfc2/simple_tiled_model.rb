module Wfc2
  class SimpleTiledModel
    # PSEUDOCODE
    # =====================================================
    # Get a grid of possible tiles with their rules
    # create a grid of output_w x output_h (2d array)
    # fill each grid cell with all possible tile options
    # pick a random starting tile
    # collapse it (pick one of the tiles)
    # propogate choice reduction to neighbors
    #   if available choices changed? propogate to its neighbors
    # if available choices reduced to 1, mark cell as collapsed
    # find cell with lowest entropy (least number/weight of available choices)
    # pick one of the remaining choices for that cell
    # back to propogation step
    # until every cell is solved or we have failed
    # return result array of tiles
    # =====================================================


    # The tile_set should be an array of Wfc2::Tile objects. Each one should be assigned
    # an identifier (most likely an array index of some sort) and a rules hash. See tile.rb
    # for rules hash structure.

    class << self
      def solve(tile_set, output_width, output_height)
        SimpleTiledModel.new(tile_set, output_width, output_height).solve
      end
    end

    def initialize(tile_set, output_width, output_height)
      @tile_set = tile_set
      @output_width = output_width
      @output_height = output_height
      # initialize processing grid
      @process_grid = []
      x = 0
      while x < @output_width
        @process_grid[x] = []
        y = 0
        while y < @output_height
          @process_grid[x][y] = Wfc2::Cell.new(@tile_set)
          y += 1
        end
        x += 1
      end
    end

    def solve
      # randomly select a first cell to collapse
      x = rand(@output_width)
      y = rand(@output_height)
      cell = @process_grid[x][y]
      cell.collapse
      propagate(cell)

      # select the cell neighbor with the lowest entropy ???
      # loop until all cells are collapsed:
        # cell.collapse
        # propagate(cell)
      # return the output things
    end

    def propagate(source_cell)
      x = source_cell.x
      y = source_cell.y

      # neighbor above
      evaluate_neighbor(source_cell, @process_grid[x][y + 1], :down) if y + 1 < @output_height
      # neighbor below
      evaluate_neighbor(source_cell, @process_grid[x][y - 1], :up) if y > 0
      # neighbor right
      evaluate_neighbor(source_cell, @process_grid[x + 1][y], :left) if x + 1 < @output_width
      # neighbor left
      evaluate_neighbor(source_cell, @process_grid[x - 1][y], :right) if x > 0
    end

    def evaluate_neighbor(source_cell, neighbor_cell, evaluation_direction)
      return if neighbor_cell.collapsed # we can't evaluate further than "collapsed"

      original_tile_count = neighbor_cell.available_tiles.length
      source_cell.available_tiles.each do |source_tile|
        neighbor_cell.available_tiles.select! do |tile|
          tile.rules[evaluation_direction].include?(source_tile.identifier)
        end
      end
      # if the number of available_tiles changed, we need to evaluate THIS cell's neighbors now
      propagate(neighbor_cell) if neighbor_cell.available_tiles.length != original_tile_count
      # stop infinite recursion!  Hand wavy
    end
  end
end

