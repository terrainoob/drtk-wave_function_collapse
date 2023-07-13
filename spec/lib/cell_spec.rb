require 'spec_helper'

describe Wfc::Cell do
  let(:x) { 0 }
  let(:y) { 0 }
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
  let(:available_tiles) do
    [
      [tile1, tile2, tile3],
      [tile4, tile5, tile6],
      [tile1, tile2, tile3]
    ]
  end
  let(:process_grid) do
    grid = Array.new(3) { Array.new(3) }
    grid[0] = [tile1, tile2, tile3]
    grid[1] = [tile4, tile5, tile6]
    grid[2] = [tile1, tile2, tile3]
    grid
  end
  let(:cell) { Wfc::Cell.new(x, y, available_tiles) }

  it '#collapse reduces the available tiles to one and sets .collapsed to true' do
    expect(cell.collapsed).to be_falsey
    cell.collapse
    expect(cell.available_tiles.length).to eq 1
    expect(cell.available_tiles[0].class).to eq Wfc::Tile
    expect(cell.collapsed).to be_truthy
  end

  it '#neighbors finds the correct neighbor tiles' do
    expect(cell.neighbors(process_grid)[:up]).to eq process_grid[0][1]
    expect(cell.neighbors(process_grid)[:down]).to eq nil
    expect(cell.neighbors(process_grid)[:left]).to eq nil
    expect(cell.neighbors(process_grid)[:right]).to eq process_grid[1][0]
  end
end
