require './test/setup'

class TestOmniStruct < Minitest::Test
  ## Struct
  def test_struct_merge
    Hash.struct_type = Struct::STRUCT_TYPE
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
    os1 = @h1.to_struct(Struct::STRUCT_TYPE)

    assert_equal os1.lock, os1, "noop"
  end

  def test_struct_unlock
    os1 = @h1.to_struct(Struct::STRUCT_TYPE)

    unlocked = os1.unlock
    assert unlocked.is_a?(ClassyHashStruct)
    assert_equal 'a', unlocked.a
  end

  def test_struct_delete
    os1 = @h1.to_struct(Struct::STRUCT_TYPE)
    assert_nil os1.delete(:bad_key)
    assert_equal "a", os1.delete(:a)
    assert_nil os1.a
  end

  def test_struct_to_json
    assert_equal '{"foo":"bar"}',
      { :foo => "bar" }.to_struct(Struct::STRUCT_TYPE).to_json
  end

  def test_struct_to_struct
    os = @h1.to_struct(Struct::STRUCT_TYPE)
    assert_equal os, os.to_struct(Struct::STRUCT_TYPE)

    ns = os.to_struct
    assert ns.is_a?(Struct), ns.class

    assert os.to_struct(OpenStruct::STRUCT_TYPE).is_a?(OpenStruct)
  end

  def test_struct_to_json
    assert_equal '{"foo":"bar"}',
      { :foo => "bar" }.to_struct(Struct::STRUCT_TYPE).to_json
  end
end
