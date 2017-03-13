require 'rails_helper'

describe "Issue API", :request do
  include_context "db_cleanup_each"
  let(:payload) { JSON.parse(response.body) }

  def validate_pass
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")
  end

  def validate_all_issues_payload_pass
    validate_pass
    expect(payload.map{|f|f["id"]}).to eq(@issues.map{|f|f[:id]})
    expect(payload.map{|f|f["issue_type"]}).to eq(@issues.map{|f|f[:issue_type]})
    expect(payload.map{|f|f["signature"]}).to eq(@issues.map{|f|f[:signature]})
    expect(payload.map{|f|f["ticket"]}).to eq(@issues.map{|f|f[:ticket]})
    expect(payload.map{|f|f["state"]}).to eq(@issues.map{|f|f[:state]})
    expect(payload.map{|f|f["note"]}).to eq(@issues.map{|f|f[:note]})
  end

  def validate_instance_payload_pass
    validate_pass
    expect(payload).to have_key("id")
    expect(payload).to have_key("issue_id")
    expect(payload).to have_key("build_id")
    expect(payload).to have_key("created_at")
    expect(payload).to have_key("updated_at")
    expect(payload).to have_key("found_at")
  end

  def validate_issue_payload_pass
    validate_pass
    expect(payload).to have_key("id")
    expect(payload).to have_key("created_at")
    expect(payload).to have_key("updated_at")
  end

  def validate_issue_payload_fail(failure_msg)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.content_type).to eq("application/json")
    expect(payload).to have_key("errors")
    expect(payload["errors"]).to have_key("full_messages")
    expect(payload["errors"]["full_messages"]).to include(failure_msg)
  end

  # Automate the passing of payload bodies as json
  ["put", "post"].each do |http_method_name|
    define_method("j#{http_method_name}") do |path, params={}, headers={}| 
      headers = headers.merge("content-type" => "application/json") if !params.empty?
      self.send(http_method_name, path, params: params.to_json, headers: headers)
    end
  end

  # Automate adding a json header
  define_method("jget") do |path, params={}, headers={}|
    headers = headers.merge("Accept" => "applictation/json")
    self.send("get", path, params: params.to_json, headers: headers)
  end

  context "caller requests list of Issues" do
    before(:each) do
      @builds = (1..5).map {|idx| FactoryGirl.create(:build) }
      @issues = @builds.map {|bld| bld.issues.create }
    end

    it "returns all Issues" do
      jget self.issues_path
      validate_all_issues_payload_pass
    end

    it "returns all Issues with instance count" do
      # Add more instances to some of the issues using the first build. 
      # Right now each issue has only one.
      more_instances = 1
      @issues.each do |iss|
        more_instances.times { iss.instances.create(:build=>@builds[0]) }
        more_instances += 1
      end
      jget self.issues_path
      validate_all_issues_payload_pass
    end

    it "returns Issues without parent Issues, includes total child instance counts" do
      issue_to_dup = @issues.pop
      issue_to_dup.update(:parent=>@issues[-1])
      jget self.issues_path + "?include_instances_count&exclude_children&include_child_instances_count"
      validate_all_issues_payload_pass
      expect(payload.map{|f|f["instances_count"]}).to eq(@issues.map{|f|f.instances.count + f.child_instances.count})
      expect(@issues[-1].instances.count + @issues[-1].child_instances.count).to be(
          issue_to_dup.instances.count + @issues[-1].instances.count
        )
    end
  end

  context "caller reports" do
    it "a new Issue with valid params" do
      iss = FactoryGirl.build(:issue)
      bld = FactoryGirl.build(:build)
      new_issue_params = {
        :issue_info => {
          :issue_type => iss[:issue_type],
          :signature => iss[:signature]
        },
        :build_info => {
          :product => bld[:product],
          :branch => bld[:branch],
          :name => bld[:name]
        }
      }
      jpost self.issues_path + "/report", new_issue_params
      validate_instance_payload_pass

      iss = Issue.find_by(:issue_type=>iss[:issue_type], 
                          :signature=>iss[:signature])
      expect(iss).to_not be_nil
      expect(iss.instances.count).to eq(1)
      expect(Build.find_by(:product=>bld[:product],
                           :branch=>bld[:branch],
                           :name=>bld[:name])).to_not be_nil
    end

    it "a new Issue with invalid params" do
      iss = FactoryGirl.build(:issue)
      jpost self.issues_path + "/report", iss.attributes
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq("application/json")
      expect(payload).to have_key("errors")
      expect(payload["errors"]).to have_key("full_messages")
      expect(payload["errors"]["full_messages"]).to include('Missing parameter')
      expect(Issue.find_by(:signature=>"test_sig")).to be_nil
    end

    it "a known Issue" do
      bld = FactoryGirl.create(:build)
      iss = bld.issues.create(:issue_type=>"test_type", 
                              :signature=>"test_sig")
      expect(iss.instances.count).to eq(1)
      known_issue_params = {
        :issue_info => {
          :issue_type => "test_type",
          :signature => "test_sig"
        },
        :build_info => {
          :product => bld[:product],
          :branch => bld[:branch],
          :name => bld[:name]
        }
      }
      jpost self.issues_path + "/report", known_issue_params
      validate_issue_payload_pass
      expect(iss.instances.count).to eq(2)
    end
  end

  context "caller marks Issue as duplicate to parent" do
    before(:each) do
      @build1 = FactoryGirl.create(:build)
      @issue1 = @build1.issues.create(
        :issue_type=>"test_type1", :signature=>"test_sig1")
      @build2 = FactoryGirl.create(:build)
      @issue2 = @build2.issues.create(
        :issue_type=>"test_type2", :signature=>"test_sig2")
    end

    def reload_issues
      @issue1.reload
      @issue2.reload
    end

    it "the same issue" do
      jput self.issue_path(@issue1.id), {:parent_id=>@issue1.id}
      validate_issue_payload_fail("Cannot set an issue's parent to itself")
    end

    it "different issues" do
      (1..5).each {@issue1.instances.create(:build=>@build1)}
      (1..10).each {@issue2.instances.create(:build=>@build2)}
      jput self.issue_path(@issue1.id), {:parent_id=>@issue2.id}
      validate_issue_payload_pass
      reload_issues
      expect(@issue1.instances.count).to_not eq(@issue2.instances.count)
    end
  end

  context "caller requests specific Issue info" do
    before(:each) do
      @builds = (1..5).map { FactoryGirl.create(:build) }
      @issue = FactoryGirl.create(:issue)
      @builds.each { |bld| @issue.instances.create(:build=>bld) }
    end

    it "returns all instances with instance counts when queried" do
      get self.issue_path(@issue.id) + "?include_instances_count", 
        params: {}, headers: {"Accept"=>"application/json"}
      validate_issue_payload_pass
      expect(payload).to have_key("instances_count")
      expect(payload["instances_count"]).to eq(@issue.instances.length)
    end

    it "returns all instances with builds when queried" do
      get self.issue_path(@issue.id) + "?expand=builds", 
        params: {}, headers: {"Accept"=>"application/json"}
      validate_issue_payload_pass
      expect(payload).to have_key ("builds")
      expect(payload["builds"].length).to eq(@builds.length)
    end
  end
end
