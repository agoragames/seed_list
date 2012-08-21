module SeedList
  class List
    def initialize(*seeds)
      @list = Array.new(seeds)
    end

    def move(s, i)
      i -= 1
      index = @list.index s
      @list.delete_at index if index < i
      @list.insert(i, s).uniq!
      self
    end

    def unshift(s)
      @list.unshift(s).uniq!
      self
    end

    def push(s)
      @list.push(s).uniq!
      self
    end

    def delete(s)
      @list.delete_if { |e| e == s }
      self
    end

    def find(s)
      i = @list.index(s)
      i.nil? ? nil : i + 1
    end

  end
end
