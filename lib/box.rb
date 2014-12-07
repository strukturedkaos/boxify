class Box
  include Dimensionable

  attr_accessor :total_count

  def initialize(width:, depth:, height:, total_count: 1)
    @width = width
    @depth = depth
    @height = height
    @total_count = total_count
  end

  def rotated
    @rotated ||= Box.new(width: height, depth: depth, height: width)
  end

  def rotate
    temp_width = width
    @width = height
    @height = temp_width
  end
end

class BoxCollection

  attr_reader :boxes

  def initialize(boxes: boxes)
    @boxes = boxes
  end

  def unplaced
    boxes.select{ |b| b.total_count > 0 }
  end

  def delete(box)
    return if box.total_count == 0
    box.total_count -= 1
  end

  def total_count
    boxes.map(&:total_count).inject(:+)
  end

  def flattened_dimensions
    @flattened_dimensions ||= boxes.map { |b| [b.width, b.height, b.depth]}.flatten.uniq.sort
  end

  def longest_edge
    @longest_edge ||= flattened_dimensions.max
  end

  def second_longest_edge
    @second_longest_edge ||= flattened_dimensions[-2]
  end

  def box_with_widest_surface_area
    boxes_sorted_by_surface_area.last
  end

  def box_with_minimum_height
    boxes_sorted_by_height.first
  end

  def more_than_one_box_with_widest_surface_area?
    number_of_boxes = unplaced.select {|b| b.surface_area == box_with_widest_surface_area.surface_area }.count
    number_of_boxes > 1
  end

  def find_eligible_boxes(space)
    unplaced.select{ |b| (b.width <= space.width) && (b.height <= space.height) }
  end

  private

  def boxes_sorted_by_surface_area
    unplaced.sort { |x,y| x.surface_area <=> y.surface_area }
  end

  def boxes_sorted_by_height
    unplaced.sort { |x,y| x.height <=> y.height }
  end
end
