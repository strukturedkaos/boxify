require './box'
require 'pry'

class Boxify

  attr_reader :boxes, :container_height, :placed_boxes, :total_number_of_boxes

  def initialize(boxes:)
    @boxes = boxes
    @container_height = 0
    @total_number_of_boxes = boxes.total_count
    @placed_boxes = []
  end

  def container_width
    @container_width ||= boxes.longest_edge
  end

  def container_depth
    @container_depth ||= boxes.second_longest_edge
  end

  def boxify
    begin
      box = find_starting_box
      increment_height(box.height)
      mark_box_as_placed(box)
      place_boxes(box)
    end while boxes.total_count != 0
    true
  end

  def place_boxes(placed_box)
    available_width = container_width - placed_box.width
    available_depth = container_depth - placed_box.depth

    # If the space is empty
    return if available_width == 0 && available_depth == 0

    # Find box that fits the space
    eligible_box = find_eligible_box(available_width, available_depth)

    # If there is no box that fits into this space return to Step 3
    return unless eligible_box

    # Determine the dimension of the space
    # as = max(ak–ai, ak–aj ) and bs = bk–bi–bj
    width = [container_width - placed_box.width, container_width - eligible_box.width].max
    depth = container_depth - placed_box.depth - eligible_box.depth

    mark_box_as_placed(eligible_box)

    place_boxes(eligible_box) if boxes.total_count != 0
  end

  def container_volume
    container_width * container_height * container_depth
  end

  def volume_of_placed_boxes
    @placed_boxes.map(&:volume).inject(:+)
  end

  def wasted_space_percentage
    (container_volume - volume_of_placed_boxes).to_f / container_volume * 100
  end

  private

  def increment_height(height)
    @container_height += height
  end

  def mark_box_as_placed(box)
    placed_boxes.push(box)
    @boxes.delete(box)
  end

  def container_width_and_depth_match_box?(box)
    (container_width - box.width == 0) && (container_depth - box.depth == 0)
  end

  def find_eligible_box(available_width, available_depth)
    eligible_boxes = boxes.find_eligible_boxes(available_width, available_depth)

    if eligible_boxes.size > 1
      # Return box with largest volume
      eligible_boxes.sort{ |b| b.volume }.first
    else
      eligible_boxes.first
    end
  end

  def find_starting_box
    boxes.more_than_one_box_with_widest_surface_area? ? boxes.box_with_minimum_height : boxes.box_with_widest_surface_area
  end
end
