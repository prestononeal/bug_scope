require 'rails_helper'

describe "Issue API", :request do
  include_context "db_cleanup_each"
  def payload
    JSON.parse(response.body)
  end

  def validate_pass
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")
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
    define_method("j#{http_method_name}") do |path,params={},headers={}| 
      headers=headers.merge("content-type" => "application/json") if !params.empty?
      self.send(http_method_name, path, params: params.to_json, headers: headers)
    end
  end

  # Automate adding a json header
  define_method("jget") do |path, params={}, headers={}|
    headers = headers.merge("Accept" => "applictation/json")
    self.send("get", path, params: params.to_json, headers: headers)
  end

  context "caller requests list of Issues" do
    it "returns all Issues sorted by descending hit counts" do
      build = FactoryGirl.create(:build)
      # The first issue by ID will have the least hits, the last will have the most
      issues = (1..5).map do |idx| 
        iss = build.issues.create(:issue_type=>"test_type_#{idx}", 
                                   :signature=>"test_sig_#{idx}")
        idx.times {iss.instances.create(:build=>build)}
        iss
      end
      jget self.issues_path + "?include_hit_count"
      validate_pass
      # Remember: the last issue by ID should be first since it has the most hits
      issues = issues.reverse
      expect(payload.count).to eq(issues.count)
      expect(payload.map{|f|f["id"]}).to eq(issues.map{|f|f[:id]})
      expect(payload.map{|f|f["issue_type"]}).to eq(issues.map{|f|f[:issue_type]})
      expect(payload.map{|f|f["signature"]}).to eq(issues.map{|f|f[:signature]})
      expect(payload.map{|f|f["ticket"]}).to eq(issues.map{|f|f[:ticket]})
      expect(payload.map{|f|f["state"]}).to eq(issues.map{|f|f[:state]})
      expect(payload.map{|f|f["note"]}).to eq(issues.map{|f|f[:note]})
    end

    it "returns all Issues with build specific hit counts" do
      build1 = FactoryGirl.create(:build)
      build2 = FactoryGirl.create(:build)

      issue = FactoryGirl.create(:issue)

      5.times { issue.instances.create(:build=>build1) }
      10.times { issue.instances.create(:build=>build2) }

      jget self.issues_path + "?build_id=#{build1.id}"
      validate_pass
      expect(payload.length).to eq(1)
      expect(payload[0]["id"]).to eq(issue.id)
      expect(payload[0]["hit_count"]).to eq(build1.instances.count)

      jget self.issues_path + "?build_id=#{build2.id}"
      validate_pass
      expect(payload.length).to eq(1)
      expect(payload[0]["id"]).to eq(issue.id)
      expect(payload[0]["hit_count"]).to eq(build2.instances.count)

      jget self.issues_path + "?include_hit_count"
      validate_pass
      expect(payload.length).to eq(1)
      expect(payload[0]["id"]).to eq(issue.id)
      expect(payload[0]["hit_count"]).to eq(build1.instances.count + build2.instances.count)
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
      jput self.issue_path(@issue1.id) + "/merge_to", {:parent_id=>@issue1.id}
      validate_issue_payload_fail("Cannot merge an issue with itself")
    end

    it "different issues" do
      (1..5).each {@issue1.instances.create(:build=>@build1)}
      (1..10).each {@issue2.instances.create(:build=>@build2)}
      total_hits = @issue1.instances.count + @issue2.instances.count
      jput self.issue_path(@issue1.id) + "/merge_to", {:parent_id=>@issue2.id}
      validate_issue_payload_pass
      reload_issues
      expect(@issue1.instances.count).to eq(0)
      expect(@issue2.instances.count).to eq(total_hits)
    end
  end

  context "caller requests specific Issue info" do
    before(:each) do
      @builds = (1..5).map { FactoryGirl.create(:build) }
      @issue = FactoryGirl.create(:issue)
      @builds.each { |bld| @issue.instances.create(:build=>bld) }
    end

    it "returns with hit counts and expands builds when queried" do
      jget self.issue_path(@issue.id) + "?expand=builds"
      validate_issue_payload_pass
      expect(payload).to have_key("hit_count")
      expect(payload).to have_key ("builds")
      expect(payload["builds"].length).to eq(@builds.length)
    end
  end
end
