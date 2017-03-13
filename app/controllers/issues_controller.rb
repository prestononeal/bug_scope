class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :similar_to, :update]

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
    begin
      build_info = params.require(:build_info)
      issue_info = params.require(:issue_info)
    rescue ActionController::ParameterMissing
      return invalid_params('Missing parameter')
    end
    # Get the build for this issue. If it doesn't exist, create it
    build = Build.find_or_create_by(:product => build_info[:product], 
                                    :branch => build_info[:branch], 
                                    :name => build_info[:name])

    # Check if an issue with this signature and type exists for this build. If not, create one
    # This will result in some duplicate issues when found across different builds.
    # Those duplicates can be linked later when the issue is triaged.
    created = false
    issue = build.issues.where(:issue_type => issue_info[:issue_type], 
                               :signature => issue_info[:signature]).first_or_create do |obj|
      # If the issue gets created, the instance linking the issue and build will also get created
      created = true
    end

    # Create an instance that points to this build and issue
    if !created
      instance = issue.instances.create(:build => build)
    else
      instance = issue.instances.where(:build => build).first
    end

    # Return the created instance
    render json: instance
  end

  # Gets related issues, based on signature. Ignore our own issue.
  def similar_to
    render json: Issue.signature(@issue.signature).where.not(:id => @issue.id)
  end

  # GET /issues
  # GET /issues.json
  def index
    # Ignore issues with a parent
    @issues = Issue.filter(
        params.slice(:include_instances_count, :build_product, :build_branch, 
                     :build_name, :build_id, :similar_to, :signature, 
                     :exclude_children)
      )
    render json: @issues
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    if params.has_key?(:expand)
      expandable = params[:expand].split(',')
      expandable.each do |item|
        # If the caller requests an unexpandable item, return failure
        return invalid_params("Cannot expand #{item}") if not @issue.respond_to? item.to_sym
      end
      render json: @issue.to_json(:include=>expandable)
    else
      render json: @issue
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    if not issue_params[:parent_id].nil?
      if issue_params[:parent_id].to_i == @issue.id
        return invalid_params("Cannot set an issue's parent to itself")
      end
    end
    if @issue.update(issue_params)
      show
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  protected
    def invalid_params(msg)
      render json: { errors: { full_messages:[msg] } }, status: :unprocessable_entity
    end

  private
    def set_issue
      # Allow callers to add the virtual "instances_count" field to this model
      @issue = Issue.filter(
        params.slice(:include_instances_count,
          :exclude_children)).find(params[:id]
        )
    end

    def issue_params
      params.permit(:ticket, :note, :parent_id)
    end
end
