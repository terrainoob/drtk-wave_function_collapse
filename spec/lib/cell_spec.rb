require 'spec_helper'

describe Wfc::Cell do
  let(:x) { 0 }
  let(:y) { 0 }
  let(:tile1) { Wfc::Tile.new(1, [nil, 1, 2, 3]) }
  let(:tile2) { Wfc::Tile.new(2, [2, 2, 4, 3]) }
  let(:tile3) { Wfc::Tile.new(3, [3, 2, 4, 5]) }
  let(:tile4) { Wfc::Tile.new(4, [3, 6, 1, 8]) }
  let(:tile5) { Wfc::Tile.new(5, [6, nil, nil, 3]) }
  let(:tile6) { Wfc::Tile.new(6, [8, 3, 3, 3]) }

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
