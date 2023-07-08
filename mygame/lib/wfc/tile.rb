class Wfc::Tile
  def initialize(pixel_sub_array)
    @pixel_sub_array = pixel_sub_array
    @index = -1
    @edges = []
    @up = []
    @down = []
    @left = []
  end

  # sets the rules for each tile
  def set_rules(tiles)
    tiles.each do |tile|
      up << tile if edges[0] == tile.edges[2]
      right << tile if edges[1] == tile.edges[3]
      down << tile if edges[2] == tile.edges[0]
      left << tile if edges[3] == tile.edges[1]
    end
  end
end