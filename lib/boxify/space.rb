module Boxify
  class Space
    include Dimensionable

    def initialize(width:, depth:, height:)
      @width = width
      @depth = depth
      @height = height
    end
  end

  class SpaceCollection
    extend Forwardable

    attr_reader :spaces

    def_delegators :@spaces, :each

    def initialize(spaces: spaces)
      @spaces = spaces
    end

    def self.find_spaces_within_space(space:, box:)
      spaces = []

      if space.depth - box.depth > 0
        spaces.push(Space.new(depth: space.depth - box.depth,
                              width: space.width,
                              height: box.height))
      end

      if space.width - box.width > 0
        spaces.push(Space.new(depth: box.depth,
                              width: space.width - box.width,
                              height: box.height))
      end

      new(spaces: spaces)
    end
  end
end
