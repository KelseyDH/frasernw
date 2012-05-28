class String
  
  def capitalize_first_letter
    self.strip!
    self.slice(0,1).capitalize + self.slice(1..-1)
  end
  
  def end_with_period
    self.strip!
    if self[-1,1] != '.'
      self + "."
    else
      self
    end
  end
  
  def punctuate
    self.capitalize_first_letter.end_with_period
  end
  
end