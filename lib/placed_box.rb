class PlacedBox
  extend Forwardable

  attr_reader :box, :level

  def_delegator :@box, :volume

  def initialize(box:, level:)
    @box = box
    @level = level
  end
end
