require 'ostruct'
require 'classy_struct'
require 'json'
require 'pp'

##
# Supports converting Hashes in to different kinds of structs via a 'to_struct'
# method.
#
# Note: ClassyStruct perferred over OpenStruct, it's faster.
##
class Hash
  CLASSY_STRUCT_NAME = "ClassyHashStruct"

  attr_accessor :struct_type
  @@struct_type = :classy_struct

  # Convert Hash to Struct, OpenStruct or ClassyStruct
  #
  # Example:
  #
  #   hash = { :foo => :bar }
  #
  #   # default
  #   s = hash.to_struct(:classy_struct)
  #   s.class
  #   #=> ClassyHashStruct
  #   hash.foo
  #   #=> :bar
  #
  #   s = hash.to_struct(:struct)
  #   s.class
  #   #=> Struct
  #
  #   s = hash.to_struct(:open_struct)
  #   s.class
  #   #=> OpenStruct
  def to_struct(type=nil)
    self.struct_type = type.nil? ? struct_type : type.to_sym

    if struct_type == :classy_struct
      begin
        Object.send(:remove_const, CLASSY_STRUCT_NAME.to_sym)
      rescue; end

      return Object.const_set(CLASSY_STRUCT_NAME, ClassyStruct.new).new(self)
    end

    self.each do |k,v|
      self[k] = v.to_struct(struct_type) if v.is_a? Hash
    end

    if struct_type == :open_struct
      # openstruct is said to be slower, so giving the option to disable
      return OpenStruct.new(self)
    end

    # otherwise use standard struct
    return nil if self.empty?

    klass = Struct.new(*keys.map{|key| key.to_sym})
    klass.new(*values)
  end

  # Return struct type for instance.
  #
  # Example:
  #
  #   hash = { :foo => :bar }
  #
  #   # default
  #   hash.struct_type
  #   #=> :classy_struct
  def struct_type
    @struct_type || @@struct_type
  end

  # Return struct type for class.
  #
  # Example:
  #
  #   Hash.struct_type
  #   #=> :classy_struct
  #
  def self.struct_type
    @@struct_type
  end

  # Set struct type for class.
  #
  # Example:
  #
  #   Hash.struct_type = :struct
  #   Hash.struct_type
  #   #=> :struct
  #   hash = { :foo => :bar }
  #   hash.struct_type
  #   #=> :struct
  def self.struct_type= type
    type = type.to_sym
    raise "Invalid struct type: #{type}." unless struct_types.include?(type)

    @@struct_type = type.to_sym
  end

  private
  def self.struct_types
    [ :classy_struct, :open_struct, :struct ]
  end
end

# ClassyStruct patches
####
class ClassyStruct
  class ClassyStructClass
    alias :to_h :to_hash

    # Convert ClassyStruct to Struct or OpenStruct
    #
    # Example:
    #
    #   struct = { :foo => :bar }.to_struct(:classy_struct)
    #
    #   # noop
    #   s = struct.to_struct
    #   s.class
    #   #=> ClassyHashStruct
    #
    #   s = struct.to_struct(:struct)
    #   s.class
    #   #=> Struct
    #
    #   s = struct.to_struct(:open_struct)
    #   s.class
    #   #=> OpenStruct
    def to_struct(type=:classy_struct)
      return self if type.to_sym == :classy_struct
      return self.to_h.to_struct(type)
    end

    def merge other
      self.to_h.merge!(other.to_h).to_struct(:classy_struct)
    end

    # Convert ClassyStruct to Struct, thus locking it.
    def lock
      self.to_h.to_struct(:struct)
    end

    def to_json
      self.to_h.to_json
    end
  end
end

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
