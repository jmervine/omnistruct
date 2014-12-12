require 'minitest/autorun'
require './test/setup'
require './omnistruct'

class TestOmniStruct < Minitest::Test
  ## Struct
  def test_struct_merge
    Hash.struct_type = :struct
    os1 = @h1.to_struct
    os2 = @h2.to_struct

    os3 = os1.merge(os2)
    os4 = os2.merge(@h1)

    assert_equal 'a', os1.a
    assert_equal 'A', os2.a
    assert_equal 'A', os3.a
    assert_equal 'a', os4.a
  end

  def test_struct_lock
    os1 = @h1.to_struct(:struct)

    assert_equal os1.lock, os1, "noop"
  end

  def test_struct_unlock
    os1 = @h1.to_struct(:struct)

    unlocked = os1.unlock
    assert unlocked.is_a?(ClassyHashStruct)
    assert_equal 'a', unlocked.a
  end

  def test_struct_to_json
    assert_equal '{"foo":"bar"}',
      { :foo => "bar" }.to_struct(:struct).to_json
  end

  def test_struct_to_struct
    os = @h1.to_struct(:struct)
    assert_equal os, os.to_struct(:struct)

    assert os.to_struct.is_a?(ClassyHashStruct)
    assert os.to_struct(:open_struct).is_a?(OpenStruct)
  end

  def test_struct_to_json
    assert_equal '{"foo":"bar"}',
      { :foo => "bar" }.to_struct(:struct).to_json
  end
end
