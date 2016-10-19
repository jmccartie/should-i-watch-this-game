class StandingsController < ApplicationController
  def index
    @standings = Table.all
  end
end
