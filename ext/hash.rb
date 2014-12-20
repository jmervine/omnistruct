require File.join(File.dirname(__FILE__), 'classystruct')
require File.join(File.dirname(__FILE__), 'openstruct')
require File.join(File.dirname(__FILE__), 'struct')

# Supports converting Hashes in to different kinds of structs via a 'to_struct'
# method.
#
# Note: ClassyStruct perferred over OpenStruct, it's faster.
class Hash
  attr_accessor :struct_type
  @@struct_type = ClassyStruct::STRUCT_TYPE

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

    if struct_type == ClassyStruct::STRUCT_TYPE
      begin
        Object.send(:remove_const, ClassyStruct::CLASS_NAME)
      rescue; end

      return Object.const_set(ClassyStruct::CLASS_NAME, ClassyStruct.new).new(self)
    end

    self.each do |k,v|
      self[k] = v.to_struct(struct_type) if v.is_a? Hash
    end

    if struct_type == OpenStruct::STRUCT_TYPE
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

  protected
  def self.struct_types
    [
      ClassyStruct::STRUCT_TYPE,
      OpenStruct::STRUCT_TYPE,
      Struct::STRUCT_TYPE
    ]
  end
end
