module Wfc
  class SimpleTiledModel
    # The tile_set should be an array of Wfc::Tile objects. Each one should be assigned
    # an identifier (most likely an tile index of some sort) and an edge_types array.
    # See tile.rb for an explanation of what the edge_types array should look like

    def initialize(tile_set, output_width, output_height)
      @tile_set = tile_set
      @output_width = output_width
      @output_height = output_height

      # initialize uncollapsed_cells grid - this grid is to make finding lowest
      # entropy faster (I think) because we can constantly reduce the number of
      # cells we need to evaluate in that function
      @uncollapsed_cells_grid = []
      # initialize processing grid - this is the final grid that will be returned
      @process_grid = Array.new(@output_width) { Array.new(@output_height) }
      x = 0
      while x < @output_width
        y = 0
        while y < @output_height
          cell = Wfc::Cell.new(x, y, @tile_set)
          @process_grid[x][y] = cell
          @uncollapsed_cells_grid << cell
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
      process_starting_cell(cell)
      @process_grid.map { |arr| arr.map { |arr2| arr2.available_tiles[0] } }
    end

    def iterate
      @uncollapsed_cells_grid.compact!
      return false if @uncollapsed_cells_grid.empty?

      next_cell = find_lowest_entropy
      return false unless next_cell

      process_starting_cell(next_cell)
      @process_grid.map { |arr| arr.map { |arr2| arr2.available_tiles[0] } }
    end

    def process_starting_cell(cell)
      cell.collapse
      @uncollapsed_cells_grid -= [cell]
      propagate(cell)
    end

    def propagate(source_cell)
      evaluate_neighbor(source_cell, :up)
      evaluate_neighbor(source_cell, :right)
      evaluate_neighbor(source_cell, :down)
      evaluate_neighbor(source_cell, :left)
    end

    def evaluate_neighbor(source_cell, evaluation_direction)
      neighbor_cell = source_cell.neighbors(@process_grid)[evaluation_direction]
      return if neighbor_cell.nil? || neighbor_cell.collapsed # we can't evaluate further than "collapsed"

      original_tile_count = neighbor_cell.available_tiles.length
      source_edge_index = DIRECTION_TO_INDEX[evaluation_direction]
      check_edge_index = DIRECTION_TO_INDEX[OPPOSITE_OF[evaluation_direction]]

      new_available_tiles = []
      source_cell.available_tiles.each do |source_tile|
        source_edge_type = source_tile.edge_types[source_edge_index]
        neighbor_cell.available_tiles.each do |tile|
          new_available_tiles << tile if tile.edge_types[check_edge_index] == source_edge_type
        end
      end
      neighbor_cell.available_tiles = new_available_tiles.uniq(&:identifier) unless new_available_tiles.empty?
      neighbor_cell.update
      @uncollapsed_cells_grid -= [neighbor_cell] if neighbor_cell.collapsed

      # if the number of available_tiles changed, we need to evaluate THIS cell's neighbors now
      propagate(neighbor_cell) if neighbor_cell.available_tiles.length != original_tile_count
    end

    def find_lowest_entropy
      @uncollapsed_cells_grid.compact!
      @uncollapsed_cells_grid.sort! { |c1, c2| c1.entropy <=> c2.entropy }
      @uncollapsed_cells_grid.first
    end
  end
end

