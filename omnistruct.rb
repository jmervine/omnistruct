Dir.glob(File.join(File.dirname(__FILE__), 'ext', '*.rb')).each do |lib|
  require lib
end
require 'json'

# Top level class, mainly for correct requiring, but wraps Hash extensions as
# well.
module OmniStruct
  # Wraps Hash.to_struct
  #
  # Examples:
  #
  #   s = OmniStruct.new({:foo => :bar})
  #   s.class
  #   #=> ClassyHashStruct
  #   s.foo
  #   #=> :bar
  #
  #   s = OmniStruct.new({:foo => :bar})
  #   s.class
  #   #=> ClassyHashStruct
  #   s.foo
  #   #=> :bar
  def self.new hash=Hash.new, type=Hash.struct_type
    return hash.to_struct(type)
  end

  # Wraps Hash.struct_type
  def self.struct_type
    Hash.struct_type
  end

  # Wraps Hash.struct_type=
  def self.struct_type= type
    Hash.struct_type = type
  end

  protected
  # Wraps Hash.struct_types
  def self.struct_types
    Hash.send(:struct_types)
  end
end
