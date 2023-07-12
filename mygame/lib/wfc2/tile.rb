module Wfc2
  class Tile
    attr_reader :identifier
    attr_accessor :rules

    # rules hash: each cardinal direction is a Set of Tile identifiers that are valid
    # in that direction from this Tile
    # Note Set is used here intead of Array because its .include? implementation is faster
    def initialize(identifier)
      @identifier = identifier
      @rules = { up: [null], down: [null], left: [null], right: [null] }
    end
  end
end
