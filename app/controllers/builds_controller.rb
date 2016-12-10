class BuildsController < ApplicationController
  before_action :set_build, only: [:show]

  # GET /builds
  # GET /builds.json
  def index
    @builds = Build.all
    render json: @builds
  end

  # GET /builds/1
  # GET /builds/1.json
  def show
    render json: @build
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build
      @build = Build.find(params[:id])
    end
end
