class Wfc2::SimpleTiledModel
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

  # class Rule
      # def create(source_tile, something)
  # end

  # How are rules created?
  # what does the tile_set structure look like?

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

    # select the cell neighbor with the lowest entropy
    # loop until all cells are collapsed:
      # cell.collapse
      # propagate(cell)
    # return the output things
  end

  def propagate(source_cell)
    x = source_cell.x
    y = source_cell.y
    # up
    evaluate_neighbor(@process_grid[x][y + 1]) if y + 1 < @output_height
    # down
    evaluate_neighbor(@process_grid[x][y - 1]) if y > 0
    # right
    evaluate_neighbor(@process_grid[x + 1][y]) if x + 1 < @output_width
    # left
    evaluate_neighbor(@process_grid[x - 1][y]) if x > 0
  end

  def evaluate_neighbor(neighbor_cell)
    # stop infinite recursion!  Hand wavy

    # determine valid remaining tiles
    # if that changed, propagate(neighbor_cell)
  end
end