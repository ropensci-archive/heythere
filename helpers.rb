class Array
  def has?(tag)
    self.collect { |x| x.match(tag) }.compact.length > 0
  end
end

class Array
  def only_packages
    self.select { |x| x['labels'].map(&:name).has?('package') }
  end
end

class Hash
  def get_info
    vars = [:url, :number, :title]
    tmp = self.select { |k,_| vars.include?(k) }
    tmp[:user] = self[:user][:login]
    tmp
  end
end
