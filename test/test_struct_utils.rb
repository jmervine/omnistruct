require 'minitest/autorun'
require './struct_utils'

class TestStructUtils < Minitest::Test
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
    Hash.class_variable_set(:@@struct_type, :classy_struct)
  end

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
