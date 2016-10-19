class MatchesController < ApplicationController
  def index
    @matches = Match.since(3).sort! { |a,b| a.watch_score <=> b.watch_score }
  end

  def show
  end
end
