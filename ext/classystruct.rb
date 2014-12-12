require File.join(File.dirname(__FILE__), 'hash')
require 'classy_struct'
require 'json'

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
