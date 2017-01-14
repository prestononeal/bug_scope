class IssuesController < ApplicationController
  skip_before_filter :verify_authenticity_token
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

  # Merges this issue to another one by updates all child instances to point to the given issue.
  # Returns the parent issue info
  def merge_to
    issue = Issue.find(params[:parent_id])

    # Allow ticket fields to stay blank if neither are set, but
    # temporarily give them blank strings for simpler logic below
    @issue.ticket = '' if @issue.ticket.nil?
    issue.ticket = '' if issue.ticket.nil?

    # Don't allow linking issues if they have conflicting tickets
    unless @issue.ticket.empty? or issue.ticket.empty?
      if @issue.ticket.downcase != issue.ticket.downcase
        return render :json => {:errors => 'Issues have conflicting tickets'}
      end
    end

    if @issue.ticket.downcase != issue.ticket.downcase
      # If one issue has a ticket and the other doesn't, update the one without it.
      # We'll do it for both instead of just the parent issue's
      if @issue.ticket.empty?
        logger.debug('Setting issue ticket to first one')
        @issue.ticket = issue.ticket
        @issue.save
      else
        logger.debug('Setting issue ticket to second one')
        issue.ticket = @issue.ticket
        issue.save
      end
    end

    # update the children instances to point to the given issue
    @issue.instances.update(:issue => issue)

    render json: @issue
  end

  # Gets related issues, based on signature. Ignore our own issue.
  def similar_to
    issues = Issue.signature(@issue.signature).where.not(:id => @issue.id)

    render json: issues
  end

  # GET /issues
  # GET /issues.json
  def index
    logger.info(params.slice(:all_issues)).to_s
    @issues = Issue.filter(
      params.slice(:all_with_instances_count, :build_product, :build_branch, :build_name, :build_id, :similar_to, :signature)
      )
    render json: @issues
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    render json: @issue.to_json(:include => :builds) 
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.all_with_instances_count.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:ticket, :note)
    end
end
