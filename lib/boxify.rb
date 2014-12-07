class Boxify
  extend Forwardable

  STARTING_LEVEL = 0

  attr_reader :boxes, :placed_boxes, :level, :container, :volume_of_placed_boxes

  def_delegators :@container, :volume_of_placed_boxes, :wasted_space_percentage
  def_delegator :@container, :height, :container_height
  def_delegator :@container, :depth, :container_depth
  def_delegator :@container, :width, :container_width
  def_delegator :@container, :volume, :container_volume

  def initialize(boxes:)
    @level = STARTING_LEVEL
    @boxes = boxes
    @placed_boxes = PlacedBoxCollection.new
    @container = Container.new(width: boxes.longest_edge, depth: boxes.second_longest_edge, height: 0)
  end

  def pack
    pack_level
    container.placed_boxes = placed_boxes
    true
  end

  def pack_level

    # Increment level of box
    increment_level

    # Get biggest box as object
    box = boxes.find_biggest_box_with_minimum_height

    # Set container height (ck = ck + ci)
    increment_height(box.height)

    # Remove box from array (ki = ki - 1)
    pack_box(box)

    # Terminate if all boxes have been packed
    return true if boxes.total_count == 0

    # No space left (not even when rotated / length and width swapped)
    if container.area - box.area <= 0
      pack_level
    else  # Space left, check if a package fits in
      space = Space.new(width: container.width, depth: container.depth, height: container.height)
      spaces = SpaceCollection.find_spaces_within_space(space: space, box: box)

      # Fill each space with boxes
      spaces.each do |space|
        fill_space(space)
      end

      pack_level if boxes.total_count > 0
    end
  end


  # Fills space with boxes recursively
  def fill_space(space)
    # Find box that fits into this space
    eligible_box = find_eligible_box(space)

    if eligible_box
      pack_box(eligible_box)

      spaces = SpaceCollection.find_spaces_within_space(space: space, box: eligible_box)

      # Fill each space with boxes
      spaces.each do |space|
        fill_space(space)
      end
    end
  end

  private

  # Set container height (ck = ck + ci)
  def increment_height(height)
    @container.height += height
  end

  def increment_level
    @level += 1
  end

  def pack_box(box)
    placed_boxes.add(box: box, level: level)
    boxes.delete(box)
  end

  def find_eligible_box(space)
    EligibleBox.find_best_fit(boxes: boxes.unplaced, space: space)
  end
end
