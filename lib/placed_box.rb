class PlacedBox
  extend Forwardable

  attr_reader :box, :level

  def_delegators :@box, :volume

  def initialize(box:, level:)
    @box = box
    @level = level
  end
end

class PlacedBoxCollection

  attr_accessor :placed_boxes

  def initialize(placed_boxes: [])
    @placed_boxes = placed_boxes
  end

  def add(box:, level:)
    @placed_boxes.push(PlacedBox.new(box: box, level: level))
  end

  def volume
    placed_boxes.map(&:volume).inject(:+)
  end
end
