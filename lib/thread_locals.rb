
class ThreadLocals
  def self.method_missing(symbol, *args)
    if symbol.to_s =~ /(.*)=$/
      name = $1.to_sym
      set(name, args.shift)
    else
      raise ArgumentError.new("wrong number of arguments (1 for 0)") if args.size != 0
      get(symbol)
    end
  end

  def self.destroy
    Thread.current[:thread_locals] = nil
  end

  def self.set(name,value)
    Thread.current[:thread_locals] ||= Hash.new
    Thread.current[:thread_locals][name.to_sym] = value
  end

  def self.get(name)
    Thread.current[:thread_locals] ||= Hash.new
    Thread.current[:thread_locals][name.to_sym]
  end
end
