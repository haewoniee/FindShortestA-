#!/usr/bin/env ruby
require 'json'
require './element'
require './priorityQueue'


def heuristic(coordinates)
	dx = (coordinates[0] - $goal_row).abs
	dy = (coordinates[1] - $goal_col).abs
	return dx + dy
end

def movables(element)
	movableArr = []
	row = element.coordinates[0]
	col = element.coordinates[1]
	set = [1,-1]
	for i in set
		if row + i > 0 && row + i < $map.length && $cost_map[$map[row+i][col]] != Float::INFINITY
			movableArr << [row+i,col]
		end
		if col + i > 0 && col + i < $map[0].length - 1 && $cost_map[$map[row][col+i]] != Float::INFINITY
			movableArr << [row,col+i]
		end
	end
	movableArr
end


def getPath(from, to)
	if from[0] - to[0] == 1
		"u"
	elsif from[0] - to[0] == -1
		"d"
	elsif from[1] - to[1] == 1
		"l"
	else 
		"r"
	end
end


# USAGE: solution.rb ./solution map.txt initial_row initial_col goal_row goal_col
mapText = ARGV[0]
initial_row = ARGV[1].to_i
initial_col = ARGV[2].to_i
$goal_row = ARGV[3].to_i
$goal_col = ARGV[4].to_i

# Read file line by line
# Add to 2-D Array
if ARGV.length == 5
	row = 0
	$map = [];
	File.open(mapText, "r") do |f|
	  f.each_line do |line|
	    $map << line;
	    row += 1
	  end
	end
	if ($goal_row >= $map.length) || ($goal_col >= $map[0].length - 2)
		p nil
	else
		$cost_map = Hash.new
		$cost_map["r"] = 1
		$cost_map["f"] = 2
		$cost_map["h"] = 5
		$cost_map["m"] = 10
		$cost_map["w"] = Float::INFINITY

		OPEN = PriorityQueue.new
		CLOSED = Array.new
		init_coor = [initial_row,initial_col]
		OPEN << Element.new(init_coor,0)

		prevs = Hash.new
		cost_until = Hash.new
		prevs[init_coor] = nil
		cost_until[init_coor] = 0
		while OPEN.length > 0
			current = OPEN.pop()
			CLOSED << current.coordinates
			if current.coordinates == [$goal_row,$goal_col]
				break
			end
			movables(current).each do |neighbor_coord|
				neighbor_letter = $map[neighbor_coord[0]][neighbor_coord[1]]
				if $cost_map[neighbor_letter] != nil
						
					f = cost_until[current.coordinates] + $cost_map[neighbor_letter]
					if OPEN.include?(Element.new(neighbor_coord,0)) && cost_until[neighbor_coord] != nil && f < cost_until[neighbor_coord]
						OPEN.remove(Element.new(neighbor_coord,0))
					end
					if !OPEN.include?(Element.new(neighbor_coord,0)) && !CLOSED.include?(neighbor_coord)
						cost_until[neighbor_coord] = f
						neighbor_cost = f + heuristic(neighbor_coord)
						OPEN << Element.new(neighbor_coord, neighbor_cost)
						prevs[neighbor_coord] = current.coordinates
					end
				end
			end
		end
		path_coor = []
		path = []

		if prevs[[$goal_row,$goal_col]] != nil
			elem = [$goal_row, $goal_col]
			while elem != nil
				path_coor << elem
				elem = prevs[elem]
			end

			coor1 = path_coor.shift
			path_coor.each do |coor|
				path << getPath(coor, coor1)
				coor1 = coor
			end
			path.reverse!

		end
		if path.length > 0
			path
		else
			path = nil
		end
		p path
	end

else
	nil
end
