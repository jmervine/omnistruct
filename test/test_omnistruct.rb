require 'minitest/autorun'
require './test/setup'
require './omnistruct'

class TestOmniStruct < Minitest::Test
  def test_omnistruct
    os = OmniStruct.new
    assert os.is_a?(ClassyHashStruct)

    os = OmniStruct.new(@h1, :open_struct)
    assert os.is_a?(OpenStruct)
    assert_equal 'a', os.a
  end
end
