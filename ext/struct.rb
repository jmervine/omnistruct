require File.join(File.dirname(__FILE__), 'hash')
require 'json'

class Struct
  # returns new object
  def merge other
    selfHash = self.to_h
    otherHash = other.is_a?(Hash) ? other : other.to_h

    selfHash.merge!(otherHash)
    selfHash.to_struct(:struct)
  end

  def lock
    self #noop
  end

  # Convert Struct to OpenStruct or ClassyStruct (default), thus unlocking it.
  def unlock(type=:classy_struct)
    return nil if type.to_sym == :struct
    return self.to_h.to_struct(type)
  end

  def to_json
    self.to_h.to_json
  end

  # Convert Struct # to OpenStruct or ClassyStruct
  #
  # Example:
  #
  #   struct = { :foo => :bar }.to_struct(:struct)
  #
  #   # noop
  #   s = struct.to_struct
  #   s.class
  #   #=> Struct
  #
  #   s = struct.to_struct(:open_struct)
  #   s.class
  #   #=> OpenStruct
  #
  #   s = struct.to_struct(:classy_struct)
  #   s.class
  #   #=> ClassyHashStruct
  def to_struct(type=:classy_struct)
    return self if type.to_sym == :struct
    return self.to_h.to_struct(type)
  end
end


