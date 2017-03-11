require 'rails_helper'

describe "Issue API", :request do
  include_context "db_cleanup_each"
  let(:payload) { JSON.parse(response.body) }

  def validate_issue_payload
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")
    expect(payload).to have_key("id")
    expect(payload).to have_key("issue_id")
    expect(payload).to have_key("build_id")
    expect(payload).to have_key("created_at")
    expect(payload).to have_key("updated_at")
    expect(payload).to have_key("found_at")
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
      validate_issue_payload

      expect(Issue.find_by(:issue_type=>iss[:issue_type], 
                           :signature=>iss[:signature])).to_not be_nil
      expect(Build.find_by(:product=>bld[:product],
                           :branch=>bld[:branch],
                           :name=>bld[:name])).to_not be_nil
    end

    it "a new Issue with invalid params" do
      expect(Issue.find_by(:signature=>new_issue_signature)).to be_nil
      new_issue_params = {
        :issue_info => {
          :issue_type => 'fault',
          :signature => new_issue_signature
        }
      }
      post "/issues/report", params: new_issue_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq("application/json")
      expect(payload).to have_key("errors")
      expect(payload["errors"]).to have_key("full_messages")
      expect(payload["errors"]["full_messages"]).to include('Missing parameter')
      expect(Issue.find_by(:signature=>new_issue_signature)).to be_nil
    end

    it "a known Issue" do
      bld = Build.create(:product=>"test_product",
                         :branch=>"test_branch",
                         :name=>"test_name")
      iss = bld.issues.create(:issue_type => "test_type", 
                              :signature => "test_sig")
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
      validate_issue_payload
      
      expect(iss.instances.count).to eq(2)
    end
  end

  context "caller merges" do
    it "the same issue"

    it "different issues with conflicting tickets" 

    it "different issues, parent issue has ticket"

    it "different issues, child issue has ticket" 
  end

end
