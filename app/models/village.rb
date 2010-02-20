class Village < ActiveRecord::Base
  Names = ['beijing', 'shanghai', 'Wuhan', 'wuhan', 'HongKong', 'hongkong', 'Hong Kong', 'hong kong', 'Qingdao', 'qingdao', 'Tsingdao', 'tsigndao', 'London', 'london', 'New York', 'new york', 'Paris', 'paris', 'Tokyo', 'tokyo', 'Hanoi', 'hanoi']

  belongs_to :user
  has_many :buildings
  validates_uniqueness_of :name
  validates_exclusion_of :name, :in => Names
  validates_inclusion_of :ration_level, :in => ['no','half','normal',
                                                'extra','double']
  def food; user.food; end

  def amount_of(building_type)
    building = self.buildings.first :conditions => {:type_id => building_type.id}
    return 0 if building.nil?
    return building.amount
  end

  def buildables
    BuildingType.all.select {|b| user.can_build? b}
  end

  def unbuildables 
    BuildingType.all.select {|b| !user.can_build? b}.take 3
  end

  def build_building(type_id, amount)
    building_type = BuildingType.find type_id
    raise "invalid building type" if building_type.nil?
    return if user.food < building_type.cost
    user.bounded_update :food, -building_type.cost, 0
    building = buildings.detect {|b| b.type_id == type_id}
    if building
      building.unbounded_update :amount, +amount
    else
      buildings.create :type_id => type_id, :amount => amount
    end
  end

  def food_consumption_per_person
    case ration_level
    when 'no' then 0
    when 'half' then 5
    when 'normal' then 10
    when 'extra' then 15
    when 'double' then 20
    end
  end

  def food_consumption
    (population * food_consumption_per_person).ceil
  end

  def food_production
    user.learned_words * 3
  end

  def net_food
    food_production - food_consumption
  end

  def starving?
    food + net_food < 0
  end

  def grow_population
    growth = population_growth.floor
    if growth >= 0
      bounded_update :population, growth, max_population
    else
      bounded_update :population, growth, 0
    end
  end

  def happiness_info
    method_names = methods.grep /^happiness_effect_of/
    result = {}
    method_names.each do |method|
      name = method.match(/^happiness_effect_of_(.+)/)[1].humanize
      result[name] = self.send method
    end
    result
  end

  def happiness_effect_of_rations
    return -3 if starving?
    case ration_level
    when 'no' then -3
    when 'half' then -1
    when 'normal' then 0
    when 'extra' then 1
    when 'double' then 2
    end
  end

  def happiness_effect_of_buildings
    happy_building_types = BuildingType.where :bonus_type => 'happiness'
    happy_buildings = buildings.select {|b| happy_building_types.include? b.type}
    happy_buildings.inject(0) do |bonus, building|
      bonus + (building.amount * building.effect)
    end
  end

  def happiness_effect_of_overcrowding
    1 - (population / 10)
  end

  def max_population
    population_buildings = buildings.select do |building| 
      building.type.bonus_type == "population"
    end
    population_buildings.inject(0) do |pop, building|
      pop + (building.amount * building.type.effect)
    end
  end

  def nom_food
    if food_production >= 0
      user.unbounded_update :food, food_production
    else
      user.bounded_update :food, food_production, 0
    end
  end

  def population_growth
    return 0 if quality_of_life >= 0 and population >= max_population
    quality_of_life
  end

  def quality_of_life
    happiness_effect_of_rations + happiness_effect_of_buildings +
      happiness_effect_of_overcrowding
  end

  def set_rations(level)
    update_attributes :ration_level => level    
  end

  def display_ration_level
    return 'Not enough food!' if starving?
    ration_level + ' rations'
  end
end
