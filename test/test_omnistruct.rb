require './test/setup'

class TestOmniStruct < Minitest::Test
  def test_omnistruct
    os = OmniStruct.new
    assert os.is_a?(ClassyHashStruct)

    os = OmniStruct.new(@h1, OpenStruct::STRUCT_TYPE)
    assert os.is_a?(OpenStruct)
    assert_equal 'a', os.a
  end
end
