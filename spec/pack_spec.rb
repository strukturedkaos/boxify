require 'spec_helper'
require 'boxify'
require 'pry'

describe Boxify::Pack do
  let(:box1) { Boxify::Box.new(width: 2, depth: 7, height: 4, total_count: 1) }
  let(:box2) { Boxify::Box.new(width: 8, depth: 10, height: 3, total_count: 1) }
  let(:box3) { Boxify::Box.new(width: 5, depth: 4, height: 10, total_count: 1) }
  let(:box4) { Boxify::Box.new(width: 2, depth: 2, height: 2, total_count: 1) }
  let(:boxes) { [box1, box2, box3, box4] }
  let(:box_collection) { Boxify::BoxCollection.new(boxes: boxes) }

  describe 'initial state' do

    subject { described_class.new(boxes: box_collection) }

    describe '#container_width' do
      it 'returns the first longest edge of all boxes' do
        expect(subject.container_width).to eq(box_collection.longest_edge)
      end
    end

    describe '#container_depth' do
      it 'returns the second longest edge of all boxes' do
        expect(subject.container_depth).to eq(box_collection.second_longest_edge)
      end
    end

    describe '#container_height' do
      it 'starts off at 0' do
        expect(subject.container_height).to eq(0)
      end
    end
  end

  describe '#pack' do
    context 'when there is only one box' do
      let(:boxes) { [box1] }
      let(:box_collection) { Boxify::BoxCollection.new(boxes: boxes) }
      let(:expected_volume_of_placed_boxes) { boxes.map(&:volume).inject(:+) }

      subject { described_class.new(boxes: box_collection) }

      it 'calculates correct container height' do
        expected_height = box_collection.box_with_widest_surface_area.height
        subject.pack
        expect(subject.container_height).to eq(expected_height)
      end

      it 'returns true when starting box is only box' do
        expect(subject.pack).to be true
      end

      it 'calculates correct volume of placed boxes' do
        subject.pack
        expect(subject.volume_of_placed_boxes).to eq(expected_volume_of_placed_boxes)
      end
    end

    context 'when there is more than one box' do
      let(:boxes) { [box1, box2, box3, box4] }
      let(:box_collection) { Boxify::BoxCollection.new(boxes: boxes) }
      let(:expected_container_height) { 13 }
      let(:expected_container_volume) { 1040 }
      let(:expected_volume_of_placed_boxes) { boxes.map(&:volume).inject(:+) }

      subject { described_class.new(boxes: box_collection) }

      before { subject.pack }

      it 'calculates correct container height' do
        expect(subject.container_height).to eq(expected_container_height)
      end

      it 'calculates correct volume of placed boxes' do
        expect(subject.volume_of_placed_boxes).to eq(expected_volume_of_placed_boxes)
      end

      it 'calculates correct percentage of wasted space' do
        expected_wasted_space_percentage = ((expected_container_volume - expected_volume_of_placed_boxes).to_f / expected_container_volume * 100).to_i
        expect(subject.wasted_space_percentage.to_i).to eq(expected_wasted_space_percentage)
      end
    end
  end
end
