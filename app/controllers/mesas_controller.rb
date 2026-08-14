class MesasController < ApplicationController
  def new
    @mesa=Mesa.new
    @mesas = Mesa.all
  end
end
