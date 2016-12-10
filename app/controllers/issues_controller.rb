class IssuesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_issue, only: [:show]

  # Report an issue.
  # Will create an instance and possibly a new issue if it hasn't been reported.
  # Must provide these parameters:
  # => issue info:
  # =>   type
  # =>   signature
  # => build info:
  # =>   product
  # =>   branch
  # =>   name
  def report
    # Get the build for this issue. If it doesn't exist, create it
    build = Build.find_or_create_by(:product => params[:build_info][:product], 
                                    :branch => params[:build_info][:branch], 
                                    :name => params[:build_info][:name])

    # Check if issue with this signature and type exists for this build. If not, create one
    issue = build.issues.where(:issue_type => params[:issue_info][:issue_type], 
                               :signature => params[:issue_info][:signature]).first_or_create

    # Create an instance that points to this build and issue
    instance = issue.instances.create

    # Return the instance info in JSON
    render json: instance
  end

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.filter(
      params.slice(:by_build_product, :by_build_branch,
                   :by_build_name, :by_build_id))
    render json: @issues
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    render json: @issue
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end
end
