class Wfc::Grid
  def initialize(width, height, resolution, tiles)
    @resolution = resolution
    @width = width / resolution
    @height = height / resolution
    @tiles = tiles
    @grid = []
    init_array
  end

  # how to draw the grid
  def draw

  end

  # initialize each Cell in the grid with the superset of tile options
  def init_array
    x = 0
    while x < @width
      y = 0
      @grid[x] = []
      while y < @height
        @grid[x][y] = Cell.new(x, y, @options)
        y += 1
      end
      x += 1
    end
  end
end