require 'minitest/autorun'
require './test/setup'
require './omnistruct'

class TestOmniStruct < Minitest::Test
  ## ClassyStruct
  def test_classy_struct_to_struct
    os = @h1.to_struct(:classy_struct)

    assert_equal os, os.to_struct

    assert os.to_struct.is_a?(ClassyHashStruct)
    assert os.to_struct(:struct).is_a?(Struct)
    assert os.to_struct(:classy_struct).is_a?(ClassyHashStruct)
  end

  def test_classy_struct_merge
    Hash.struct_type = :classy_struct

    os1 = @h1.to_struct
    os2 = @h2.to_struct

    assert_equal 'A', os1.merge(os2).a
    assert_equal 'a', os2.merge(@h1).a
  end

  def test_classy_struct_lock
    os1 = @h1.to_struct(:classy_struct)

    locked = os1.lock
    assert locked.is_a?(Struct)
    assert_equal 'a', locked.a
  end

  def test_classy_struct_to_json
    Hash.struct_type = :classy_struct
    s1 = { :foo => "bar" }.to_struct
    s2 = { :bar => "bar" }.to_struct

    assert_equal '{"foo":"bar"}', s1.to_json
    assert_equal '{"bar":"bar"}', s2.to_json

    # ensuring that new classy struct's don't mess with old ones
    assert_equal '{"foo":"bar"}', s1.to_json
  end
end
