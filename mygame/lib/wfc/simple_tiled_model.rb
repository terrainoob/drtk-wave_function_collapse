module Wfc
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


    # The tile_set should be an array of Wfc::Tile objects. Each one should be assigned
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
      @process_grid = Array.new(@output_width) { Array.new(@output_height) }
      x = 0
      while x < @output_width
        y = 0
        while y < @output_height
          @process_grid[x][y] = Wfc::Cell.new(x, y, @tile_set, @process_grid)
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

      x = 0 # temporary
      while x < 100 # what do we check here? How do we know when the last cell is collapsed?
        # find the uncollapsed neighbor with the lowest entropy to collapse next
        sorted_neighbor_array = cell.neighbors.sort_by do |a, b|
          a.available_tiles.length <=> b.available_tiles.length
        end.reject(&:collapsed)
        next_cell = sorted_neighbor_array[0]
        next_cell.collapse
        propagate(next_cell)
        x += 1 # temporary
      end
      # the following might be complete BS. Does this work? Works on my whiteboard!
      @process_grid.map { |arr| arr.map { |arr2| arr2.available_tiles[0] } }
    end

    def propagate(source_cell)
      evaluate_neighbor(source_cell, source_cell.neighbors[:up], :down)
      evaluate_neighbor(source_cell, source_cell.neighbors[:down], :up)
      evaluate_neighbor(source_cell, source_cell.neighbors[:right], :left)
      evaluate_neighbor(source_cell, source_cell.neighbors[:left], :right)
    end

    def evaluate_neighbor(source_cell, neighbor_cell, evaluation_direction)
      return if neighbor_cell.nil? || neighbor_cell.collapsed # we can't evaluate further than "collapsed"

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

