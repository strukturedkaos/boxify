require 'spec_helper'

describe Boxify::Box do
  subject { described_class.new(width: 2, depth: 7, height: 4) }

  describe '#surface_area' do
    it 'calculates the surface area as 2*height*width + 2*height*depth + 2*width*depth' do
      surface_area = (2 * subject.height * subject.width) + (2 * subject.height * subject.depth) + (2 * subject.width * subject.depth)
      expect(subject.surface_area).to eq surface_area
    end
  end

  describe '#volume' do
    it 'calculates the volume as length * width * depth' do
      volume = subject.height * subject.width * subject.depth
      expect(subject.volume).to eq volume
    end
  end
end


describe Boxify::BoxCollection do
  let(:box1) { Boxify::Box.new(width: 2, depth: 7, height: 4, total_count: 1) }
  let(:box2) { Boxify::Box.new(width: 8, depth: 10, height: 3, total_count: 1) }
  let(:box3) { Boxify::Box.new(width: 5, depth: 4, height: 10, total_count: 1) }
  let(:box4) { Boxify::Box.new(width: 2, depth: 2, height: 2, total_count: 1) }

  subject { described_class.new(boxes: [box1, box2, box3, box4]) }

  describe '#unplaced' do
    let(:box5) { Boxify::Box.new(width: 18, depth: 18, height: 19, total_count: 0) }

    subject { described_class.new(boxes: [box1, box2, box3, box4, box5]) }

    it 'only returns boxes with a count greater than 0' do
      expect(subject.unplaced).to_not include(box5)
      expect(subject.unplaced.size).to eq(4)
    end
  end

  describe '#longest_edge' do
    it 'finds the longest edge of all the boxes' do
      expect(subject.longest_edge).to eq(10)
    end
  end

  describe '#second_longest_edge' do
    it 'finds the second longest edge of all the boxes' do
      expect(subject.second_longest_edge).to eq(8)
    end
  end

  describe '#box_with_widest_surface_area' do
    it 'finds the box with the widest surface area' do
      expect(subject.box_with_widest_surface_area).to eq(box2)
    end
  end

  describe '#box_with_minimum_height' do
    it 'finds the box with the smallest height' do
      expect(subject.box_with_minimum_height).to eq(box4)
    end
  end

  describe '#more_than_one_box_with_widest_surface_area?' do
    context 'when no 2 boxes have the widest surface area' do
      it 'returns false' do
        expect(subject.more_than_one_box_with_widest_surface_area?).to be false
      end
    end

    context 'when 2 boxes both have the widest surface area' do
      let(:box1) { Boxify::Box.new(width: 2, depth: 8, height: 10, total_count: 1) }
      let(:box2) { Boxify::Box.new(width: 8, depth: 10, height: 2, total_count: 1) }

      subject { described_class.new(boxes: [box1, box2]) }

      it 'returns true' do
        expect(subject.more_than_one_box_with_widest_surface_area?).to be true
      end
    end
  end

  describe 'unavailable boxes vs available boxes' do
  end
end
