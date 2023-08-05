require 'lib/wfc/wfc.rb'
require 'lib/wfc/cell.rb'
require 'lib/wfc/simple_tiled_model.rb'
require 'lib/wfc/overlapping_model.rb'
require 'lib/tiled/tiled.rb'

def tick args
  if args.tick_count.zero?
    args.state.iteration = 0
    args.state.tileset = Tiled::Tileset.load('sprites/forest/tileset.tsx')
    tiles = create_tile_array(args.state.tileset)
    args.state.model = Wfc::SimpleTiledModel.new(tiles, 45, 25)
  end

  #######################################################################
  # This section runs the entire solver at once and THEN paints the map
  # press 'a' to solve the entire map
  #######################################################################
  if args.inputs.keyboard.a
    tiled_map = args.state.model.solve_all
    args.state.tiled_map = tiled_map
    refresh_target(args, tiled_map)
  end

  #######################################################################
  # This section will #iterate one step at a time to see the actual map generation
  # press 's' once to start the solver and then
  # press 'i' to solve each iteration iteration
  #######################################################################
  if args.inputs.keyboard.s
    tiled_map = args.state.model.solve
    args.state.tiled_map = tiled_map
    refresh_target(args, tiled_map)
  end

  if args.inputs.keyboard.i
    args.state.iteration += 1
    tiled_map = args.state.model.iterate
    if tiled_map && args.state.iteration
      args.state.tiled_map = tiled_map
      refresh_target(args, tiled_map)
    end
  end

  #######################################################################
  # press 'r' to reset the map
  #######################################################################
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
    {
      identifier: id,
      edge_types: wangtile.wangid4,
      probability: wangtile.tile.probability.to_f || 1.0
    }
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
  args.state.iteration = 0
end

def tile_id(tile)
  tile.available_tiles.map(&:identifier)
end