class UiController < ApplicationController
  def index
    render 'public/index.html', layout: false
  end
end
