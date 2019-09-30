class PriorityQueue
	def initialize
		@elements = []
		@length = 0;
	end

	def length
		@length
	end

	def <<(element)
		@elements << element
		heapify_up(@length)
		@length += 1
	end

	def pop()
		if @length >= 1
			popped = @elements.shift
			@elements.unshift(@elements.pop())
			@length -= 1
			if @length == 0
				@elements = []
			end
			heapify_down(0)
			popped
		else 
			@elements = []
		end
	end

	def remove(element)
		new_elements = []
		new_length = 0
		@elements.each do |e|
			if e != element
				new_elements << e
				heapify_up(new_length)
				new_length += 1
			end
		end
		@length = new_length
		@elements = new_elements
	end

	def lowest()
		@elements.first
	end

	def heapify_up(last_idx)
		parent_idx = (last_idx - 1) / 2

		if last_idx <= 0 || @elements[parent_idx] < @elements[last_idx]
			return
		else
			@elements[last_idx],@elements[parent_idx] = @elements[parent_idx],@elements[last_idx]
		end
		heapify_up(parent_idx)
	end

	def heapify_down(idx)
		child_idx = (idx * 2 + 1)
		if child_idx >= (@length - 1)
			return
		end
		if (child_idx + 1) < @length
			if @elements[child_idx + 1] <= @elements[child_idx]
				child_idx = child_idx + 1
			end
		end
		@elements[idx],@elements[child_idx] = @elements[child_idx],@elements[idx]
		heapify_down(child_idx)
	end
	def include?(elem)
		@elements.include?(elem)
	end

end
