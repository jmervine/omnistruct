require File.join(File.dirname(__FILE__), 'hash')
require 'ostruct'
require 'json'

class OpenStruct
  # replaces object
  def merge! other
    self.marshal_load(merge(other).to_h)
  end

  # returns new object
  def merge other
    OpenStruct.new(self.marshal_dump.merge(other.to_h))
  end

  def to_json
    self.marshal_dump.to_json
  end

  # Convert OpenStruct to Struct, thus locking it.
  def lock
    self.marshal_dump.to_struct(:struct)
  end

  def unlock
    self # noop
  end

  # Convert OpenStruct to Struct or ClassyStruct
  #
  # Example:
  #
  #   struct = { :foo => :bar }.to_struct(:classy_struct)
  #
  #   # noop
  #   s = struct.to_struct
  #   s.class
  #   #=> OpenStruct
  #
  #   s = struct.to_struct(:struct)
  #   s.class
  #   #=> Struct
  #
  #   s = struct.to_struct(:classy_struct)
  #   s.class
  #   #=> ClassyHashStruct
  def to_struct(type=:open_struct)
    return self if type.to_sym == :open_struct
    return self.marshal_dump.to_struct(type)
  end
end
