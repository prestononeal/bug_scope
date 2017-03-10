require 'rails_helper'

describe "Issue API", type: :request do
  include_context "db_cleanup_each"

  context "caller requests list of Issues" do
    it_should_behave_like "resource index", :issue do
      let(:response_check) do
        expect(payload.count).to eq(resources.count);
        expect(payload.map{|f|f["id"]}).to eq(resources.map{|f|f[:id]})
        expect(payload.map{|f|f["issue_type"]}).to eq(resources.map{|f|f[:issue_type]})
        expect(payload.map{|f|f["signature"]}).to eq(resources.map{|f|f[:signature]})
        expect(payload.map{|f|f["ticket"]}).to eq(resources.map{|f|f[:ticket]})
        expect(payload.map{|f|f["state"]}).to eq(resources.map{|f|f[:state]})
        expect(payload.map{|f|f["note"]}).to eq(resources.map{|f|f[:note]})
      end
    end
  end
end
