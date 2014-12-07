class Container
  include Dimensionable

  attr_accessor :placed_boxes

  def initialize(width:, depth:, height:)
    @width = width
    @depth = depth
    @height = height
  end

  def volume_of_placed_boxes
    placed_boxes.volume
  end

  def wasted_space_percentage
    (volume - volume_of_placed_boxes).to_f / volume * 100
  end
end
