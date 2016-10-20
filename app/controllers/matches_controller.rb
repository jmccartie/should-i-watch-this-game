class MatchesController < ApplicationController
  def index
    @matches = Match.since(6).sort! { |a,b| b.watch_score <=> a.watch_score }
  end

  def show
  end
end
