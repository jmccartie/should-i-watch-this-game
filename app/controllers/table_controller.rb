class TableController < ApplicationController
  def index
    @teams = Table.all
  end
end
