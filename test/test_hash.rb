require 'minitest/autorun'
require './test/setup'
require './omnistruct'

class TestOmniStruct < Minitest::Test
  def test_hash_to_struct
    s = @h1.to_struct
    assert s.is_a?(ClassyHashStruct)
    assert_equal 'a', s.a

    s = @h1.to_struct(:open_struct)
    assert s.is_a?(OpenStruct)
    assert_equal s.a, 'a'
    assert_equal s.b, 'b'

    s = @h1.to_struct(:struct)
    assert s.is_a?(Struct)
    assert_equal s.a, 'a'
    assert_equal s.b, 'b'

    h = Hash.new
    assert_nil h.to_struct(:struct),
      "empty hash to Struct should be nil"
  end

  def test_hash_struct_type
    assert_equal :classy_struct, Hash.struct_type
    assert_equal :classy_struct, Hash.new.struct_type

    Hash.struct_type=:open_struct
    assert_equal :open_struct, Hash.struct_type
    assert_equal :open_struct, Hash.new.struct_type

    h = { :foo => :bar }
    h.struct_type = :struct
    assert_equal :struct, h.struct_type

    s = h.to_struct(:struct)
    assert s.is_a?(Struct)

    assert_raises(RuntimeError) {
      Hash.struct_type=:bad_type
    }
  end
end
