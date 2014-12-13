module Boxify
  module Dimensionable
    attr_accessor :width, :depth, :height

    def area
      width * depth
    end

    def volume
      width * height * depth
    end

    def surface_area
      (2 * height * width) + (2 * height * depth) + (2 * width * depth)
    end
  end
end
