require 'minitest/autorun'
require './test/setup'
require './omnistruct'

class TestOmniStruct < Minitest::Test
  # OpenStruct
  def test_openstruct_merge!
    Hash.struct_type = :open_struct

    os1 = @h1.to_struct
    os2 = @h2.to_struct

    os1.merge!(os2)
    os2.merge!(@h1)

    assert_equal os1.a, 'A'
    assert_equal os2.a, 'a'
  end

  def test_openstruct_merge
    Hash.struct_type = :open_struct

    os1 = @h1.to_struct
    os2 = @h2.to_struct

    os3 = os1.merge(os2)
    os4 = os2.merge(@h1)

    assert_equal os1.a, 'a'
    assert_equal os2.a, 'A'

    assert_equal os3.a, 'A'
    assert_equal os4.a, 'a'
  end

  def test_openstruct_lock
    os1 = @h1.to_struct(:open_struct)

    locked = os1.lock
    assert locked.is_a?(Struct)
    assert_equal 'a', locked.a
  end

  def test_openstruct_unlock
    os1 = @h1.to_struct(:open_struct)

    assert_equal os1.unlock, os1, "noop"
  end

  def test_openstruct_to_json
    assert_equal '{"foo":"bar"}',
      { :foo => "bar" }.to_struct(:open_struct).to_json
  end

  def test_openstruct_to_struct
    os = @h1.to_struct(:open_struct)

    assert_equal os, os.to_struct
    assert os.to_struct.is_a?(OpenStruct)

    assert os.to_struct.is_a?(OpenStruct)
    assert os.to_struct(:struct).is_a?(Struct)
    assert os.to_struct(:classy_struct).is_a?(ClassyHashStruct)
  end
end
