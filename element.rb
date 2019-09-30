class Element
    include Comparable

    attr_accessor :coordinate, :priority

    def initialize(coordinate, priority)
        @coordinate, @priority = coordinate, priority
    end

    def <=>(other)
        if other == nil
            return nil
        end
        @priority <=> other.priority
    end

    def ==(other)
        if other == nil
            return nil
        end
        @coordinate == other.coordinate
    end
end

