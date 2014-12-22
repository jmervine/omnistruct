require File.join(File.dirname(__FILE__), 'common')
require 'classy_struct'

# ClassyStruct patches
####
class ClassyStruct
  STRUCT_TYPE = :classy_struct
  CLASS_NAME  = "ClassyHashStruct"

  class ClassyStructClass

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
    include CommonStruct

    def struct_type
      STRUCT_TYPE
    end

    def merge other
      self.to_h.merge!(other.to_h).to_struct(STRUCT_TYPE)
    end

    # Convert ClassyStruct to Struct, thus locking it.
    def lock
      self.to_h.to_struct(Struct::STRUCT_TYPE)
    end

    alias :to_h :to_hash
  end
end
