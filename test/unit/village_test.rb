require 'test_helper'

class VillageTest < ActiveSupport::TestCase
  def setup
    @v = villages(:one)
  end

  def test_unique_name
    new = Village.create :name => @v.name, :ration_level => 'normal'
    assert_equal false, new.save
    new = Village.create :name => (rand(10000).to_s), :ration_level => 'normal'
    assert new.save
    new = Village.create :name => 'Hong Kong', :ration_level => 'normal'
    assert_equal false, new.save
  end

  def test_defaults
    new = Village.create :name => @v.name
    assert_equal 1, new.population
    assert_equal 'normal', new.ration_level
  end
end
