require 'box_packer'

BoxPacker.container [8, 10, 13], label: 'Parcel', quantity: 1 do
  add_item [7, 2, 4], label: 'Shoes', quantity: 1
  add_item [10, 8, 3], label: 'Shoes', quantity: 1
  add_item [4, 5, 10], label: 'Watch', quantity: 1
  add_item [2, 2, 2], label: 'Bag', quantity: 1
  pack! # returns 2

  # puts packed_successfully           # true
  # puts packings.count                # 2
  # puts packings[0].include? items[1] # false
  # puts packings[0][1].position       # (5,0,0)


  puts self # |Container| Parcel 20x15x13 Weight Limit:50 Packings Limit:3
            # |  Packing| Remaining Volume:3870 Remaining Weight:3
            # |     Item| Shoes 5x3x2 (0,0,0) Volume:30 Weight:47
            # |  Packing| Remaining Volume:3870 Remaining Weight:3
            # |     Item| Shoes 5x3x2 (0,0,0) Volume:30 Weight:47
            # |  Packing| Remaining Volume:3887 Remaining Weight:19
            # |     Item| Watch 3x3x1 (0,0,0) Volume:9 Weight:24
            # |     Item| Bag 4x1x1 (3,0,0) Volume:4 Weight:7
end
