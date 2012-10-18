require 'spec_helper'

describe SeedList::Model do
  let(:tournament){ FactoryGirl.create :tournament }
  subject { tournament.seed_list }

  its(:serialized_attributes) { subject.keys.should include('list') }
end
