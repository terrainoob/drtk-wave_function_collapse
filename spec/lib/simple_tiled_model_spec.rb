require 'spec_helper'

describe Wfc::SimpleTiledModel do
  let(:output_width) { 4 }
  let(:output_height) { 4 }
  let(:tile1) do
    tile = Wfc::Tile.new(1)
    tile.rules = { up: nil, down: [4], right: [2], left: nil }
    tile
  end
  let(:tile2) do
    tile = Wfc::Tile.new(2)
    tile.rules = { up: nil, down: [5], right: [3], left: [1] }
    tile
  end
  let(:tile3) do
    tile = Wfc::Tile.new(3)
    tile.rules = { up: nil, down: [6], right: nil, left: [2] }
    tile
  end
  let(:tile4) do
    tile = Wfc::Tile.new(4)
    tile.rules = { up: [1], down: nil, right: [5], left: nil }
    tile
  end
  let(:tile5) do
    tile = Wfc::Tile.new(5)
    tile.rules = { up: [2], down: nil, right: [6], left: [4] }
    tile
  end
  let(:tile6) do
    tile = Wfc::Tile.new(6)
    tile.rules = { up: [3], down: nil, right: nil, left: [5] }
    tile
  end
  let(:tileset) do
    grid = Array.new(3) { Array.new(3) }
    grid[0] = [tile1, tile2, tile3]
    grid[1] = [tile4, tile5, tile6]
    grid[2] = [tile1, tile2, tile3]
    grid
  end

  it 'returns an array with the correct size' do
    result = Wfc::SimpleTiledModel.solve(tileset, output_width, output_height)
    puts result
    expect(result.length).to eq output_width
  end
end