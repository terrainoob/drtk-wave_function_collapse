require 'lib/wfc/wfc.rb'
require 'lib/wfc/cell.rb'
require 'lib/wfc/tile.rb'
require 'lib/wfc/simple_tiled_model.rb'
require 'lib/wfc/overlapping_model.rb'
require 'lib/tiled/tiled.rb'

def tick args
  if args.tick_count.zero?
    args.state.tileset = Tiled::Tileset.load('sprites/forest/tileset.tsx')
    tiles = create_tile_array(args.state.tileset)
    args.state.model = Wfc::SimpleTiledModel.new(tiles, 45, 25)
    tiled_map = args.state.model.solve
    args.state.tiled_map = tiled_map
    refresh_target(args, tiled_map)
  end

  if args.inputs.keyboard.i
    tiled_map = args.state.model.iterate
    if tiled_map
      args.state.tiled_map = tiled_map
      refresh_target(args, tiled_map)
    end
  end

  if args.inputs.keyboard.key_down.r
    args.state.tileset = Tiled::Tileset.load('sprites/forest/tileset.tsx')
    tiles = create_tile_array(args.state.tileset)
    args.state.model = Wfc::SimpleTiledModel.new(tiles, 45, 25)
    tiled_map = args.state.model.solve
    args.state.tiled_map = tiled_map
    refresh_target(args, tiled_map)
  end

  args.outputs.sprites << {
    x: 0,
    y: 0,
    w: args.state.model.output_width * 13 * 2,
    h: args.state.model.output_height * 13 * 2,
    source_w: args.state.model.output_width * 13,
    source_h: args.state.model.output_height * 13,
    path: :map
  }
end

def create_tile_array(tileset)
  tileset.wangsets.last.tiles.map do |id, wangtile|
    Wfc::Tile.new(id, wangtile.wangid4, wangtile.tile.probability.to_f || 1.0)
  end
end

def refresh_target(args, tiled_map)
  target = args.outputs[:map]
  target.width = args.state.model.output_width * 13
  target.height = args.state.model.output_height * 13
  target.background_color = [0,0,0]
  target.sprites << tiled_map.map_2d do |x, y, wfc_tile|
    next unless wfc_tile
    args.state.tileset.sprite_at(x * 13, y * 13, wfc_tile.identifier)
  end
end

def tile_id(tile)
  tile.available_tiles.map(&:identifier)
end