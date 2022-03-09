require 'singleton'

class Store
  include Singleton

  def initialize
    @data = []
    @mutex = Mutex.new
  end

  def save(object)
    @mutex.synchronize do
      @data << object
    end
  end

  def find_by(args)
    @mutex.synchronize do
      @data.find do |object|
        args.keys.all? { |key| object[key] == args[key] }
      end
    end
  end

  def pop_by(args)
    @mutex.synchronize do
      obj = @data.find do |object|
        args.keys.all? { |key| object[key] == args[key] }
      end
      @data.delete(obj) if obj
      obj
    end
  end
end
