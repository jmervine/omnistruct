require File.join(File.dirname(__FILE__), 'hash')
require File.join(File.dirname(__FILE__), 'common')

class Struct
  STRUCT_TYPE = :struct

  def struct_type
    STRUCT_TYPE
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
  include CommonStruct

  # returns new object
  def merge other
    selfHash = self.to_h
    otherHash = other.is_a?(Hash) ? other : other.to_h

    selfHash.merge!(otherHash)
    selfHash.to_struct(STRUCT_TYPE)
  end

  def lock
    self #noop
  end

  # Convert Struct to OpenStruct or ClassyStruct (default), thus unlocking it.
  def unlock(type=ClassyStruct::STRUCT_TYPE)
    return nil if type.to_sym == Struct::STRUCT_TYPE
    return self.to_h.to_struct(type)
  end
end
