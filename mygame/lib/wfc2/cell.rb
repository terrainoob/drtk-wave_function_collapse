class Wfc2::Cell
  attr_reader :x, :y, :available_tiles, :collapsed

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
end