class VillageController < ApplicationController
  before_filter :get_village
  skip_before_filter :get_village, :only => [:create]

  def build
    @village.build_building params[:type_id].to_i, 1
    index
    render :index
  end

  def food_info
    render :partial => 'food_info'
  end

  def quality_of_life_info
    render :partial => 'quality_of_life'
  end

  def set_rations
    @village.set_rations params[:ration_level]
    index
    render :index
  end

  def index
  end

  def new
    @village = @user.build_village
  end

  def create
    @village = @user.build_village params[:village]
    if @village.save
      flash[:notice] = "You have founded the village of #{@village.name}. " +
        "May it grow and prosper."
      index
      render :index
    else
      flash[:notice] = 'That name appears to have been taken. Please choose another.'
      new
      render :new
    end
  end

  def locked
    hut = BuildingType.first_where(:name => 'Hut')
    @requirements = hut.flashcards_required @user
  end

  private

  def get_village
    locked and render :locked and return unless @user.village_unlocked?
    new and render :new and return unless @user.has_village?
    @village = @user.village
  end
end
