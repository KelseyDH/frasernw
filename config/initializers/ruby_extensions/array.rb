class Array
  # deep copy
  def clone
    Marshal.load(Marshal.dump(self))
  end

  def unique_push(elem)
    self << elem unless self.include?(elem)

    self
  end

  # based on a uniquing function
  def subsets
    # we're going to gradually reduce this clone down as we pull out matching elements
    copy = self.clone

    self.inject([]) do |memo, elem|
      # get the items in the copy that match this one according to our function
      subset = copy.select do |inner_elem|
        yield(inner_elem) == yield(elem)
      end

      memo << subset if subset.any?

      # so we don't get duplicate dupe sets...
      copy.delete_if do |inner_elem|
        yield(inner_elem) == yield(elem)
      end

      memo
    end
  end

  def combinations(upto = self.length)
    (0..upto).inject([]) do |memo, size|
      memo + self.combination(size).to_a
    end
  end

  def except(*values)
    self - values
  end

  def to_nil_hash
    self.inject({}) do |memo, elem|
      memo.merge(elem => nil)
    end
  end
end
