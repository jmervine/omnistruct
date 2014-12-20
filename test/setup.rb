require 'minitest/autorun'
require './omnistruct'

class TestOmniStruct < Minitest::Test
  def setup
    @h1 = {
      :a => 'a',
      :b => 'b'
    }

    @h2 = {
      :a => 'A',
      :c => 'C'
    }

    # always reset default
    Hash.class_variable_set(:@@struct_type, ClassyStruct::STRUCT_TYPE)
  end
end
