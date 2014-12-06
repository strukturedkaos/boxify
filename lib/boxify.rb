class Boxify

  attr_reader :boxes, :container_height, :placed_boxes, :total_number_of_boxes, :level

  def initialize(boxes:)
    @boxes = boxes
    @container_height = 0
    @total_number_of_boxes = boxes.total_count
    @placed_boxes = []
    @level = 0
  end

  def container_width
    @container_width ||= boxes.longest_edge
  end

  def container_depth
    @container_depth ||= boxes.second_longest_edge
  end

  def container_area
    @container_area ||= container_width * container_depth
  end

  def container_volume
    container_width * container_height * container_depth
  end

  def volume_of_placed_boxes
    placed_boxes.map(&:volume).inject(:+)
  end

  def wasted_space_percentage
    (container_volume - volume_of_placed_boxes).to_f / container_volume * 100
  end

  def pack
    pack_level
  end

  def pack_level

    # Increment level of box
    increment_level

    # Get biggest box as object
    box = find_biggest_box_with_minimum_height

    # Set container height (ck = ck + ci)
    increment_height(box.height)

    # Remove box from array (ki = ki - 1)
    pack_box(box)

    # Terminate if all boxes have been packed
    return true if boxes.total_count == 0

    # No space left (not even when rotated / length and width swapped)
    if container_area - box.area <= 0
      pack_level
    else  # Space left, check if a package fits in
      space = Space.new(width: container_width, depth: container_depth, height: container_height)
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
    @container_height += height
  end

  def increment_level
    @level += 1
  end

  def pack_box(box)
    placed_boxes.push(PlacedBox.new(box: box, level: level))
    @boxes.delete(box)
  end

  def container_width_and_depth_match_box?(box)
    (container_width - box.width == 0) && (container_depth - box.depth == 0)
  end

  def find_eligible_box(space)
    EligibleBox.find_best_fit(boxes: boxes.unplaced, space: space)
  end

  # Find biggest (widest surface) box with minimum height
  def find_biggest_box_with_minimum_height
    boxes.more_than_one_box_with_widest_surface_area? ? boxes.box_with_minimum_height : boxes.box_with_widest_surface_area
  end
end
