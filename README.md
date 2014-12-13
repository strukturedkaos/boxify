Boxify
=====

A heuristic first-fit 3D box packing algorithm.

Background
----------

The gem uses "An Efficient Algorithm for 3D Rectangular Box Packing" paper by M. Zahid Gürbüz, Selim Akyokus, Ibrahim Emiroglu and Aysun Güran. It contains a step-by-step explanation of the problem and the solution.

[PDF file of the document](http://www.zahidgurbuz.com/yayinlar/An%20Efficient%20Algorithm%20for%203D%20Rectangular%20Box%20Packing.pdf)

Installation
------------

Install gem:

```console
gem  install 'boxify'
```

Or add to Gemfile:

```ruby
gem  'boxify'
```

Usage
-----

```ruby
require 'boxify'

box1 = Boxify::Box.new(width: 2, depth: 7, height: 4, total_count: 1)
box2 = Boxify::Box.new(width: 8, depth: 10, height: 3, total_count: 1)
box3 = Boxify::Box.new(width: 5, depth: 4, height: 10, total_count: 1)
box4 = Boxify::Box.new(width: 2, depth: 2, height: 2, total_count: 1)
boxes = [box1, box2, box3, box4] }
box_collection = Boxify::BoxCollection.new(boxes: boxes)
pack = Boxify::Pack.new(boxes: box_collection)
pack.pack
```
