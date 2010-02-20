class RankingsController < ApplicationController
  def biggest_villages
    @villages = Village.all :order => "population DESC", :limit => 20
  end

  def best_vocabulary
    @links = ['biggest_villages', 'best_vocabulary']
    @users = User.all.sort{|u, v| v.learned_words <=> u.learned_words}
  end

  def index
    best_vocabulary
    render :best_vocabulary
    # @links = ['biggest_villages', 'best_vocabulary']
  end
end
