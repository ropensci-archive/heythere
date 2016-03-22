class Array
  def has?(tag)
    self.collect { |x| x.match(tag) }.compact.length > 0
  end
end

class Array
  def only_packages
    # self.select { |x| x['labels'].map(&:name).has?(ENV['HEYTHERE_LABEL_TARGET']) }
    self.select { |x| x['labels'].map(&:name).has?(Heythere.label_target) }
  end
end

class Hash
  def get_info
    vars = [:url, :number, :title]
    tmp = self.select { |k,_| vars.include?(k) }
    tmp[:user] = self[:user][:login]
    return tmp
  end
end

def days_since(x)
  return (Date.parse(Time.now.getutc.to_s) - Date.parse(x.to_s)).to_f.floor
end

def days_plus_day(x)
  return Date.parse((Time.now + x.days).to_s).strftime("%b %d")
end

class Fixnum
  def days
    self * 86400
  end
end
