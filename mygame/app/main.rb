require 'lib/wfc/wfc.rb'
require 'lib/wfc/cell.rb'
require 'lib/wfc/tile.rb'
require 'lib/wfc/simple_tiled_model.rb'
require 'lib/wfc/overlapping_model.rb'

def tick args
  args.outputs.labels  << [640, 540, 'Hello World!', 5, 1]
  args.outputs.labels  << [640, 500, 'Docs located at ./docs/docs.html and 100+ samples located under ./samples', 5, 1]
  args.outputs.labels  << [640, 460, 'Join the Discord server! https://discord.dragonruby.org', 5, 1]

  args.outputs.sprites << { x: 576,
                            y: 280,
                            w: 128,
                            h: 101,
                            path: 'dragonruby.png',
                            angle: args.state.tick_count }

  args.outputs.labels  << { x: 640,
                            y: 60,
                            text: './mygame/app/main.rb',
                            size_enum: 5,
                            alignment_enum: 1 }

  if args.tick_count.zero?
    tiles = create_tile_array
    args.state.model = Wfc::SimpleTiledModel.new(tiles, 10, 10)
    tiled_map = args.state.model.solve
    puts tiled_map
    # display the first iteration of tiled_map
  end

  while tiled_map = args.state.model.iterate
    # display each solution iteration of tiled_map
    puts tiled_map
  end
end

def create_tile_array
  tiles = Array.new(9)
  9.times do |x|
    tile = Wfc::Tile.new(rand(1000), [3,1,3,2]) # for now, just give some random identifier for testing
    tiles[x] = tile
  end
  tiles
end