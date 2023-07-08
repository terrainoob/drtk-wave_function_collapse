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
    @opts[:sample_size] ||= 3
    @opts[:symmetry] ||= false
    @source_pixels = source_pixel_array.pixels
  end
end
