require File.join(File.dirname(__FILE__), 'common')
require 'ostruct'

class OpenStruct
  STRUCT_TYPE = :open_struct

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
  include CommonStruct

  def struct_type
    STRUCT_TYPE
  end

  # replaces object
  def merge! other
    self.marshal_load(merge(other).to_h)
  end

  # returns new object
  def merge other
    OpenStruct.new(self.to_h.merge(other.to_h))
  end

  # Convert OpenStruct to Struct, thus locking it.
  def lock
    self.to_h.to_struct(Struct::STRUCT_TYPE)
  end

  def unlock
    self # noop
  end

  alias :to_h :marshal_dump
  alias :to_hash :to_h
end
