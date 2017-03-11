require 'rails_helper'

describe "Issue API", :request do
  include_context "db_cleanup_each"
  let(:payload) { JSON.parse(response.body) }

  def validate_instance_payload_pass
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")
    expect(payload).to have_key("id")
    expect(payload).to have_key("issue_id")
    expect(payload).to have_key("build_id")
    expect(payload).to have_key("created_at")
    expect(payload).to have_key("updated_at")
    expect(payload).to have_key("found_at")
  end

  def validate_issue_payload_pass
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")
    expect(payload).to have_key("id")
    expect(payload).to have_key("created_at")
    expect(payload).to have_key("updated_at")
  end

  def validate_issue_payload_fail (failure_msg)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.content_type).to eq("application/json")
    expect(payload).to have_key("errors")
    expect(payload["errors"]).to have_key("full_messages")
    expect(payload["errors"]["full_messages"]).to include(failure_msg)
  end

  context "caller requests list of Issues" do
    let!(:issues) { (1..5).map {|idx| FactoryGirl.create(:issue) } }
    it "returns all Issue instances" do
      get "/issues", headers: {"Accept"=>"application/json"}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json")
      expect(payload.count).to eq(payload.count)
      expect(payload.map{|f|f["id"]}).to eq(issues.map{|f|f[:id]})
      expect(payload.map{|f|f["issue_type"]}).to eq(issues.map{|f|f[:issue_type]})
      expect(payload.map{|f|f["signature"]}).to eq(issues.map{|f|f[:signature]})
      expect(payload.map{|f|f["ticket"]}).to eq(issues.map{|f|f[:ticket]})
      expect(payload.map{|f|f["state"]}).to eq(issues.map{|f|f[:state]})
      expect(payload.map{|f|f["note"]}).to eq(issues.map{|f|f[:note]})
    end
  end

  context "caller reports" do
    let(:new_issue_signature) { "test_sig" }
    it "a new Issue with valid params" do
      iss = FactoryGirl.build(:issue)
      bld = FactoryGirl.build(:build)

      expect(Issue.find_by(:issue_type=>iss[:issue_type], 
                           :signature=>iss[:signature])).to be_nil
      expect(Build.find_by(:product=>bld[:product],
                           :branch=>bld[:branch],
                           :name=>bld[:name])).to be_nil
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
      post "/issues/report", params: new_issue_params
      validate_instance_payload_pass

      iss = Issue.find_by(:issue_type=>iss[:issue_type], 
                          :signature=>iss[:signature])
      expect(iss).to_not be_nil
      expect(iss.instances).to_not be_nil
      expect(Build.find_by(:product=>bld[:product],
                           :branch=>bld[:branch],
                           :name=>bld[:name])).to_not be_nil
    end

    it "a new Issue with invalid params" do
      iss = FactoryGirl.build(:issue)
      post "/issues/report", params: iss.attributes
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq("application/json")
      expect(payload).to have_key("errors")
      expect(payload["errors"]).to have_key("full_messages")
      expect(payload["errors"]["full_messages"]).to include('Missing parameter')
      expect(Issue.find_by(:signature=>new_issue_signature)).to be_nil
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
      post "/issues/report", params: known_issue_params
      validate_issue_payload_pass
      
      expect(iss.instances.count).to eq(2)
    end
  end

  context "caller merges two issues," do
    let!(:build) { FactoryGirl.create(:build) }
    let!(:issue) { build.issues.create(:issue_type=>"test_type", :signature=>"test_sig")}
    it "the same issue" do
      put "/issues/#{issue.id}/merge_to", params: {:parent_id => issue.id}
      validate_issue_payload_fail("Cannot merge an issue to itself")
    end

    it "with invalid params" do
      put "/issues/#{issue.id}/merge_to", params: {}
      validate_issue_payload_fail("Missing parameter: parent_id")
    end

    it "conflicting tickets" do
      issue1 = build.issues.create(:issue_type=>"test_type",
                                   :signature=>"test_sig",
                                   :ticket=>"test_ticket1")
      issue2 = build.issues.create(:issue_type=>"test_type",
                                   :signature=>"test_sig",
                                   :ticket=>"test_ticket2")
      put "/issues/#{issue1.id}/merge_to", params: {:parent_id => issue2.id}
      validate_issue_payload_fail("Issues have conflicting tickets")
    end

    it "parent issue has ticket" do
      issue1 = build.issues.create(:issue_type=>"test_type",
                                   :signature=>"test_sig",
                                   :ticket=>"test_ticket1")
      issue2 = build.issues.create(:issue_type=>"test_type",
                                   :signature=>"test_sig")
      put "/issues/#{issue1.id}/merge_to", params: {:parent_id => issue2.id}
      validate_issue_payload_pass
    end

    it "child issue has ticket" do
      issue1 = build.issues.create(:issue_type=>"test_type",
                                   :signature=>"test_sig")
      issue2 = build.issues.create(:issue_type=>"test_type",
                                   :signature=>"test_sig",
                                   :ticket=>"test_ticket2")
      put "/issues/#{issue1.id}/merge_to", params: {:parent_id => issue2.id}
      validate_issue_payload_pass
    end

    it "instances point to original issues in db"

    it "parent issue info includes child instances"
  end

end
