require 'spec_helper'

describe Wfc::SimpleTiledModel do
  let(:tiles) do
    [
      { identifier: 0, edge_types: [1, 3, 6, 1], probability: 0.0 },
      { identifier: 1, edge_types: [1, 3, 2, 3], probability: 0.0 },
      { identifier: 2, edge_types: [1, 1, 4, 3], probability: 0.0 },
      { identifier: 3, edge_types: [1, 1, 1, 1], probability: 10.0 },
      { identifier: 4, edge_types: [2, 5, 4, 2], probability: 0.0 },
      { identifier: 5, edge_types: [2, 5, 1, 5], probability: 0.0 },
      { identifier: 6, edge_types: [2, 2, 6, 5], probability: 0.0 },
      { identifier: 7, edge_types: [6, 2, 6, 1], probability: 0.0 },
      { identifier: 8, edge_types: [2, 2, 2, 2], probability: 5.0 },
      { identifier: 9, edge_types: [4, 1, 4, 2], probability: 0.0 },
      { identifier: 10, edge_types: [1, 1, 1, 1], probability: 0.6 },
      { identifier: 11, edge_types: [4, 1, 4, 2], probability: 0.0 },
      { identifier: 12, edge_types: [1, 1, 1, 1], probability: 0.3 },
      { identifier: 13, edge_types: [6, 2, 6, 1], probability: 0.0 },
      { identifier: 14, edge_types: [6, 5, 1, 1], probability: 0.0 },
      { identifier: 15, edge_types: [2, 5, 1, 5], probability: 0.0 },
      { identifier: 16, edge_types: [4, 1, 1, 5], probability: 0.0 },
      { identifier: 17, edge_types: [1, 1, 1, 1], probability: 0.6 },
      { identifier: 18, edge_types: [4, 3, 2, 2], probability: 0.0 },
      { identifier: 19, edge_types: [1, 3, 2, 3], probability: 0.0 },
      { identifier: 20, edge_types: [6, 2, 2, 3], probability: 0.0 },
      { identifier: 21, edge_types: [1, 10, 11, 1], probability: 0.1 },
      { identifier: 22, edge_types: [1, 1, 10, 10], probability: 0.1 },
      { identifier: 23, edge_types: [1, 1, 1, 1], probability: 0.6 },
      { identifier: 24, edge_types: [1, 1, 1, 1], probability: 0.6 }
    ]
  end

  let(:output_width) { 5 }
  let(:output_height) { 5 }
  let(:model) { Wfc::SimpleTiledModel.new(tiles, output_width, output_height) }

  before do
    srand(12345) # set the global rand seed so we can test consistently
  end

  context '#solve' do
    before do
      @result = model.solve
    end

    it 'returns an array with the correct size' do
      expect(@result.length).to eq output_width
      expect(@result[0].length).to eq output_height
    end

    it 'it collapses a randomly selected starting cell' do
      expect(model.process_grid[2][1].collapsed).to be_truthy
    end
  end

  context '#iterate' do
    before do
      model.solve
    end

    it 'returns an array with the correct size' do
      result = model.iterate
      expect(result.length).to eq output_width
      expect(result[0].length).to eq output_height
    end

    it 'collapses at least one more cell' do
      model.iterate
      expect(model.process_grid.flatten.filter(&:collapsed).count).to be >= 2
    end
  end

  context '#solve_all' do
    before do
      @result = model.solve_all
    end

    it 'returns an array with the correct size' do
      expect(@result.length).to eq output_width
      expect(@result[0].length).to eq output_height
    end

    it 'collapses all cells' do
      expect(model.process_grid.flatten.filter(&:collapsed).count).to eq output_width * output_height
    end
  end

  context 'completed iterative run' do
    before do
      model.solve
      {} while model.iterate
    end

    it 'eventually collapses all cells' do
      expect(model.process_grid.flatten.filter(&:collapsed).count).to eq output_width * output_height
    end

    it 'returns valid identifiers in each result cell' do
      model.result_grid.flatten.each do |tile|
        expect((0..24).to_a).to include(tile[:identifier])
      end
    end
  end

  skip context 'profiling' do
    let(:model) { Wfc::SimpleTiledModel.new(tiles, 50, 50) }

    before do
      RubyProf.measure_mode = RubyProf::WALL_TIME
    end

    after do
      path = "/home/chris/apps/wfc/tmp/profiles/"
      printer = RubyProf::MultiPrinter.new(@prof_result, %i[flat graph_html])
      printer.print(path: path, profile: "profile-_#{Time.now.strftime('%H%M%S')}")
    end

    it 'profiles iterations' do
      RubyProf.start
      model.solve
      {} while model.iterate
      @prof_result = RubyProf.stop
    end

    it 'profiles solve_all' do
      RubyProf.start
      model.solve_all
      @prof_result = RubyProf.stop
    end
  end
end
