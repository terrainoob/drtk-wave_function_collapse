require 'spec_helper'

describe Wfc::SimpleTiledModel do
  let(:output_width) { 10 }
  let(:output_height) { 10 }
  let(:tileset) { [] }

  it 'returns an array with the correct size' do
    result = Wfc::SimpleTiledModel.solve(tileset, output_width, output_height)
    expect(result.length).to eq output_width
  end
end