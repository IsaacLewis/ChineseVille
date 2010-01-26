require 'test_helper'

class WordListTest < ActiveSupport::TestCase
  def setup
    @u1 = users(:one)
    @u2 = users(:two)
  end

  def test_users_lists
    assert_nil @u1.current_list
    assert_equal "ListOne", @u2.current_list.name
  end
end
