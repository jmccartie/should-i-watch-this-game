class MatchesController < ApplicationController
  def index
    @matches = Match.all.sort! { |a,b| b.watch_score <=> a.watch_score }
  end

  def show
  end
end
