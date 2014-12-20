require './test/setup'

class TestOmniStruct < Minitest::Test
  def test_hash_to_struct
    s = @h1.to_struct
    assert s.is_a?(ClassyHashStruct)
    assert_equal 'a', s.a

    s = @h1.to_struct(OpenStruct::STRUCT_TYPE)
    assert s.is_a?(OpenStruct)
    assert_equal s.a, 'a'
    assert_equal s.b, 'b'

    s = @h1.to_struct(Struct::STRUCT_TYPE)
    assert s.is_a?(Struct)
    assert_equal s.a, 'a'
    assert_equal s.b, 'b'

    h = Hash.new
    assert_nil h.to_struct(Struct::STRUCT_TYPE),
      "empty hash to Struct should be nil"
  end

  def test_hash_struct_type
    assert_equal ClassyStruct::STRUCT_TYPE, Hash.struct_type
    assert_equal ClassyStruct::STRUCT_TYPE, Hash.new.struct_type

    Hash.struct_type=OpenStruct::STRUCT_TYPE
    assert_equal OpenStruct::STRUCT_TYPE, Hash.struct_type
    assert_equal OpenStruct::STRUCT_TYPE, Hash.new.struct_type

    h = { :foo => :bar }
    h.struct_type = Struct::STRUCT_TYPE
    assert_equal Struct::STRUCT_TYPE, h.struct_type

    s = h.to_struct(Struct::STRUCT_TYPE)
    assert s.is_a?(Struct)

    assert_raises(RuntimeError) {
      Hash.struct_type=:bad_type
    }
  end
end
