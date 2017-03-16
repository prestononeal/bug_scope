class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :similar_to, :merge_to, :update]

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
    # Those duplicates can be merged later when the issue is triaged.
    created = false
    issue = build.issues.where(:issue_type => issue_info[:issue_type], 
                               :signature => issue_info[:signature]).first_or_create do |obj|
      # If the issue gets created, the instance merging the issue and build will also get created
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

  # Merges this issue to another one by updates all child instances to point to the given issue.
  # Returns the parent issue info
  def merge_to
    begin
      parent_id = params.require(:parent_id)
    rescue ActionController::ParameterMissing
      return invalid_params('Missing parameter: parent_id')
    end

    return invalid_params('Cannot merge an issue with itself') if @issue.id == parent_id.to_i

    issue = Issue.find(parent_id)

    # Allow ticket fields to stay blank if neither are set, but
    # temporarily give them blank strings for simpler logic below
    @issue.ticket = '' if @issue.ticket.nil?
    issue.ticket = '' if issue.ticket.nil?

    # Don't allow merging issues if they have conflicting tickets
    unless @issue.ticket.empty? or issue.ticket.empty?
      if @issue.ticket.downcase != issue.ticket.downcase
        return invalid_params('Issues have conflicting tickets')
      end
    end

    if @issue.ticket.downcase != issue.ticket.downcase
      # If one issue has a ticket and the other doesn't, update the one without it.
      # We'll do it for both instead of just the parent issue's
      if @issue.ticket.empty?
        logger.debug('Setting issue ticket to first one')
        @issue.update(:ticket=>issue.ticket)
      else
        logger.debug('Setting issue ticket to second one')
        issue.update(:ticket=>@issue.ticket)
      end
    end

    # update the children instances to point to the given issue
    @issue.instances.update_all(:issue_id => issue.id)

    # Return the parent's info
    render json: issue
  end

  # Gets related issues, based on signature. Ignore our own issue.
  def similar_to
    render json: Issue.signature(
      @issue.signature).where.not(:id => @issue.id)
  end

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.filter(
      params.slice(:build_product, :build_branch, 
                   :build_name, :build_id, :similar_to, :signature, :include_hit_count)
      )
    render json: @issues
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    expandable = params[:expand]
    if expandable
      expandable = expandable.split(',')
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
      begin
        # For a single Issue, always include hit count
        @issue = Issue.include_hit_count.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        invalid_params("Issue #{params[:id]} not found")
      end
    end

    def issue_params
      params.permit(:ticket, :note, :parent_id)
    end
end
