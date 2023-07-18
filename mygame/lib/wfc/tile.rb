module Wfc
  class Tile
    attr_reader :identifier, :edge_types, :probability

    # edge_types: the edge type identifiers of each of the four edges of this tile
    #             these are expected to be passed in as an array with the first
    #             element being the top edge type and then proceeding clockwise.
    #             So:
    #             edge_types[top, right, bottom, left]

    def initialize(identifier, edge_types, probability = 1)
      @identifier = identifier
      @edge_types = edge_types
      @probability = probability
    end
  end
end
