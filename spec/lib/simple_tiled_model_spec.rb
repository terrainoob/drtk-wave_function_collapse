require 'spec_helper'

describe Wfc::SimpleTiledModel do
  let(:output_width) { 50 }
  let(:output_height) { 50 }
  # let(:output_width) { 4 }
  # let(:output_height) { 4 }
  let(:tile1) { Wfc::Tile.new(1, [nil, 1, 2, 3], 0.5) }
  let(:tile2) { Wfc::Tile.new(2, [2, 2, 4, 3], 0.1) }
  let(:tile3) { Wfc::Tile.new(3, [3, 2, 4, 5], 0.15) }
  let(:tile4) { Wfc::Tile.new(4, [3, 6, 1, 8], 0.075) }
  let(:tile5) { Wfc::Tile.new(5, [6, nil, nil, 3], 0.15) }
  let(:tile6) { Wfc::Tile.new(6, [8, 3, 3, 3], 0.025) }

  let(:tileset) do
    grid = Array.new(3) { Array.new(3) }
    grid[0] = [tile1, tile2, tile3]
    grid[1] = [tile4, tile5, tile6]
    grid[2] = [tile1, tile2, tile3]
    grid
  end
  let(:model) { Wfc::SimpleTiledModel.new(tileset, output_width, output_height) }

  it 'returns an array with the correct size' do
    result = model.solve
    expect(result.length).to eq output_width
    expect(result[0].length).to eq output_height
  end

  it 'returns an array with valid adjoining tile identifiers' do
    RubyProf.start
    model.solve
    while model.iterate
      # puts 'not sure what to actually test here yet'
    end
    prof_result = RubyProf.stop
    File.open "/home/chris/apps/wfc/tmp/profile-graph.html", 'w+' do |file|
      RubyProf::GraphHtmlPrinter.new(prof_result).print(file)
    end
  end
end