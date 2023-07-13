module Wfc2
  class Tile
    attr_reader :identifier
    attr_accessor :rules

    # rules hash: each cardinal direction is a Set of Tile identifiers that are valid
    # in that direction from this Tile

    # Note an implementation of cruby's Set should used here intead of Array because
    # its .include? implementation is faster
    # However, that's not mechanically necessary.  Array will work.
    def initialize(identifier)
      @identifier = identifier
      @rules = { up: [nil], down: [nil], left: [nil], right: [nil] }
    end
  end
end
