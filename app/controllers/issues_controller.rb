class IssuesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_issue, only: [:show, :similar_to]

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

    # Check if an issue with this signature and type exists for this build. If not, create one
    # This will result in some duplicate issues when found across different builds.
    # Those duplicates can be linked later when the issue is triaged.
    created = false
    issue = build.issues.where(:issue_type => params[:issue_info][:issue_type], 
                               :signature => params[:issue_info][:signature]).first_or_create do |obj|
      # If the issue gets created, the instance linking the issue and build will also get created
      created = true
    end

    # Create an instance that points to this build and issue
    if !created
      instance = issue.instances.create(:build => build)
    else
      instance = issue.instances.where(:build => build).first
    end

    # Return the instance info in JSON
    render json: instance
  end

  # Gets related issues, based on signature. Ignore our own issue.
  def similar_to
    issues = Issue.where(:signature=>@issue.signature)
      .where.not(:id => @issue.id)
    render json: issues
  end

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.filter(
      params.slice(:build_product, :build_branch, :build_name, :build_id, :similar_to)
      )
    render json: @issues
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    render json: @issue.to_json(:include => :builds) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end
end
