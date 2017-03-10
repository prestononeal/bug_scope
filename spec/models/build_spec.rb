require 'rails_helper'

describe Build, :model do
  include_context "db_cleanup", :transaction
  before(:all) do
    @build = FactoryGirl.create(:build)
  end
  let(:build) { Build.find(@build.id) }

  context "created Build" do
    it { expect(build).to be_persisted }
    it { expect(build.name).to_not be_nil }
    it { expect(build.branch).to_not be_nil }
    it { expect(build.product).to_not be_nil }
    it { expect(build.created_at).to_not be_nil }
    it { expect(build.updated_at).to_not be_nil }
  end

end
