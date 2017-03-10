require 'rails_helper'

describe Instance, :model do
  include_context "db_cleanup", :transaction
  before(:all) do
    issue = FactoryGirl.create(:issue)
    build = FactoryGirl.create(:build)
    @instance = FactoryGirl.create(:instance, :issue_id=>issue.id, 
      :build_id=>build.id)
  end
  let(:instance) { Instance.find(@instance.id) }

  context "created Instance" do
    it { expect(instance).to be_persisted }
    it { expect(instance.issue_id).to_not be_nil }
    it { expect(instance.build_id).to_not be_nil }
    it { expect(instance.created_at).to_not be_nil }
    it { expect(instance.updated_at).to_not be_nil }
    it { expect(instance.found_at).to_not be_nil }
  end

end
