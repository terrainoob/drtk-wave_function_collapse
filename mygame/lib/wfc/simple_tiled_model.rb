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
          @process_grid[x][y] = Wfc::Cell.new(x, y, @tile_set)
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

      #  every time we successfully collapse a cell, remove that cell from unsolved_cells
      #  each unsolved cell should keep an entropy value
      #  find next unsolved cell, collapse it, and propagate it.

      # the following might be complete BS. Does this work? Works on my whiteboard!
      @process_grid.map { |arr| arr.map { |arr2| arr2.available_tiles[0] } }
    end

    def propagate(source_cell)
      evaluate_neighbor(source_cell, source_cell.neighbors(@process_grid)[:up], :down)
      evaluate_neighbor(source_cell, source_cell.neighbors(@process_grid)[:down], :up)
      evaluate_neighbor(source_cell, source_cell.neighbors(@process_grid)[:right], :left)
      evaluate_neighbor(source_cell, source_cell.neighbors(@process_grid)[:left], :right)
    end

    def evaluate_neighbor(source_cell, neighbor_cell, evaluation_direction)
      return if neighbor_cell.nil? || neighbor_cell.collapsed # we can't evaluate further than "collapsed"

      original_tile_count = neighbor_cell.available_tiles.length

      new_available_tiles = []
      source_cell.available_tiles.each do |source_tile|
        neighbor_cell.available_tiles.each do |tile|
          new_available_tiles << tile if tile.rules[evaluation_direction]&.include?(source_tile.identifier)
        end
      end
      neighbor_cell.available_tiles = new_available_tiles.uniq(&:identifier) unless new_available_tiles.empty?
      neighbor_cell.update

      # if the number of available_tiles changed, we need to evaluate THIS cell's neighbors now
      propagate(neighbor_cell) if neighbor_cell.available_tiles.length != original_tile_count

      # stop infinite recursion!  Hand wavy
    end
  end
end

