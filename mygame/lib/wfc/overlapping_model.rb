# usage:
# Wfc::OverlappingModel.new.generate(pixel_array, 100, 100, { sample_size: 3, symmetry: false })

class Wfc::OverlappingModel
  # Parameters:
  # (required)
  # source_pixel_array: the pixel array of the source (training) image
  # width: width of the output (required)
  # height: height of the final generated image (required)
  # opts:
  # sample_size: number of pixels used as samples in the source image (optional - defaults to 3)
  # symmetry: whether the algorithm can use rotational and mirrored symmetries to match (optional - defaults to false)
  def generate(source_pixel_array, output_width, output_height, **opts)
    @opts = opts
    @sample_size = @opts[:sample_size] || 3
    @symmetry = @opts[:symmetry] || false
    @source_pixels = source_pixel_array.pixels
    @output_width = output_width
    @output_height = output_height
    @tiles = []
    slice_pixels

    # pick a random starting cell
    x = rand(0...@width)
    y = rand(0...@height)
    starting_cell = @grid[x][y]
    collapse_cell(starting_cell)
  end

  # slices the pixel array into @tiles based on the sample size
  def slice_pixels
    # @tiles = something ???
  end

  # the Grid is the "wave" part of WFC
  def initialize_grid
    @grid = Grid.new(@output_width, @output_height, @sample_size, @tiles)
  end

  # collapse an individual cell and update its neighbors
  def collapse_cell(cell)
    cell.collapse
    # update the cell's neighbors to remove any options that aren't valid anymore
  end

  # this is the main algorithm loop
  def collapse
    # while something
    #   current_cell = find_cell_with_lowest_entropy
    #   collapse_cell(current_cell)
    # end
  end
end
