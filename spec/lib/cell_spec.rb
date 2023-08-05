require 'spec_helper'

describe Wfc::Cell do
  let(:x) { 0 }
  let(:y) { 0 }
  let(:available_tiles) do
    [
      { identifier: 1, edge_types: [1, 2, 2, 1], probability: 0.5 },
      { identifier: 2, edge_types: [2, 1, 4, 3], probability: 0.1 },
      { identifier: 3, edge_types: [1, 3, 5, 1], probability: 0.15 },
      { identifier: 4, edge_types: [3, 4, 1, 3], probability: 0.075 },
      { identifier: 5, edge_types: [5, 2, 1, 4], probability: 0.15 },
      { identifier: 6, edge_types: [4, 5, 3, 2], probability: 0.025 }
    ]
  end

  let(:process_grid) do
    grid = Array.new(3) { Array.new(3) }
    grid[0] = [available_tiles[0], available_tiles[1], available_tiles[2]]
    grid[1] = [available_tiles[3], available_tiles[4], available_tiles[5]]
    grid[2] = [available_tiles[0], available_tiles[1], available_tiles[2]]
    grid
  end

  let(:cell) { Wfc::Cell.new(x, y, available_tiles) }

  before do
    srand(12345) # set the global rand seed so we can test consistently
  end

  it '#collapse reduces the available tiles to one and sets .collapsed to true' do
    expect(cell.collapsed).to be_falsey
    cell.collapse
    expect(cell.available_tiles.length).to eq 1
    expect(cell.available_tiles[0][:identifier]).to eq 1
    expect(cell.collapsed).to be_truthy
  end

  it '#neighbors finds the correct neighbor tiles' do
    expect(cell.neighbors(process_grid)[:up]).to eq process_grid[0][1]
    expect(cell.neighbors(process_grid)[:down]).to eq nil
    expect(cell.neighbors(process_grid)[:left]).to eq nil
    expect(cell.neighbors(process_grid)[:right]).to eq process_grid[1][0]
  end
end
