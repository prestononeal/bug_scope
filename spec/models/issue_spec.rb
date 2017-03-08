require 'rails_helper'

describe Issue, type: :model do
  include_context "db_cleanup", :transaction
  before(:all) do
    @issue = FactoryGirl.create(:issue)
  end
  let(:issue) { Issue.find(@issue.id) }

  context "created Issue" do
    it { expect(issue).to be_persisted }
    it { expect(issue.issue_type).to_not be_nil }
    it { expect(issue.signature).to_not be_nil }
    it { expect(issue.note).to_not be_nil }
    it { expect(issue.created_at).to_not be_nil }
    it { expect(issue.updated_at).to_not be_nil }
  end

end
