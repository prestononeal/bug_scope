require 'rails_helper'

describe "Issue API", :request do
  include_context "db_cleanup_each"
  let(:payload) { JSON.parse(response.body) }
  let!(:resources) { (1..5).map {|idx| FactoryGirl.create(:issue) } }

  context "caller requests list of Issues" do
    it "returns all Issue instances" do
      get "/issues", headers: {"Accept"=>"application/json"}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json")
      expect(payload.count).to eq(payload.count)
      expect(payload.map{|f|f["id"]}).to eq(resources.map{|f|f[:id]})
      expect(payload.map{|f|f["issue_type"]}).to eq(resources.map{|f|f[:issue_type]})
      expect(payload.map{|f|f["signature"]}).to eq(resources.map{|f|f[:signature]})
      expect(payload.map{|f|f["ticket"]}).to eq(resources.map{|f|f[:ticket]})
      expect(payload.map{|f|f["state"]}).to eq(resources.map{|f|f[:state]})
      expect(payload.map{|f|f["note"]}).to eq(resources.map{|f|f[:note]})
    end
  end

  context "caller reports" do
    let(:new_issue_signature) { 'test_sig' }
    it "a new Issue with valid params" do
      expect(Issue.find_by(:signature=>new_issue_signature)).to be_nil
      new_issue_params = {
        :issue_info => {
          :issue_type => 'fault',
          :signature => new_issue_signature
        },
        :build_info => {
          :product => 'new_product',
          :branch => 'new_branch',
          :name => 'new_name'
        }
      }
      post "/issues/report", params: new_issue_params
      expect(Issue.find_by(:signature=>new_issue_signature)).to_not be_nil
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
      expect(payload).to have_key("errors")
      expect(payload["errors"]).to have_key("full_messages")
      expect(payload["errors"]["full_messages"]).to include('Missing parameter')
      expect(Issue.find_by(:signature=>new_issue_signature)).to be_nil
    end

    it "a known Issue"
  end

  context "caller merges" do
    it "the same issue"

    it "different issues with conflicting tickets" 

    it "different issues, parent issue has ticket"

    it "different issues, child issue has ticket" 
  end

end
