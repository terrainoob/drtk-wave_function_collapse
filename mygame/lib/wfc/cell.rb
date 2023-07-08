# a Cell is an individual array cell in the final output

class Wfc::Cell
  attr_reader :x, :y, :collapsed
  attr_accessor :tile_options

  # parameters:
  # x, y : the x,y coordinates in the final output array
  # tile_options: the array of available tile options left for this cell
  def initialize(x, y, tile_options)
    @x = x
    @y = y
    @tile_options = tile_options
    @option = nil
    @collapsed = false
  end

  # returns the pixel array for the cell
  def draw
    # use final @option to draw
  end

  # returns the entropy (# of options remaining) for the cell
  def entropy
    @tile_options.length
  end

  # determine whether or not the cell has been collapsed
  def collapsed
    @tile_options.length == 1
  end

  # select a random option from the possible options
  def collapse
    return if @tile_options.length.zero?

    @option = @tile_options.sample
    @collapsed = true
  rescue StandardError => e
    puts "Exception collapsing cell [#{@x},#{@y}]: #{e.message}"
    @collapsed = false
  end
end
