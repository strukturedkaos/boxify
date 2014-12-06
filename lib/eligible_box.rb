class EligibleBox

  attr_reader :boxes, :space

  def initialize(boxes:, space:)
    @boxes = boxes
    @space = space
  end

  def self.find_all(boxes:, space:)
    new(boxes: boxes, space: space).eligible_boxes
  end

  def self.find_best_fit(boxes:, space:)
    new(boxes: boxes, space: space).eligible_box_with_largest_volume
  end

  def eligible_boxes
    @eligible_boxes ||= find_eligible_boxes
  end

  def eligible_box_with_largest_volume
    @eligible_box_with_largest_volume ||= find_box_with_largest_volume(eligible_boxes)
  end

  private

  def find_eligible_boxes
    da_boxes = boxes.select do |box|
      true if (box.width <= space.width) && (box.height <= space.height)

      rotated_copy = box.rotated
      if (rotated_copy.width <= space.width) && (rotated_copy.height <= space.height)
        box.rotate
        true
      end
    end
    da_boxes
  end

  def find_box_with_largest_volume(boxes)
    if boxes.size > 1
      # Return box with largest volume
      boxes.sort{ |b| b.volume }.first
    else
      boxes.first
    end
  end
end
