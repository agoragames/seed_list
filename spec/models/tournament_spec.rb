describe Tournament do
  let(:tournament){ FactoryGirl.create :tournament }
  subject { tournament }

  its(:serialized_attributes) { subject.keys.should include('players_seed_list') }

  describe '#players_seed_list' do
    subject { tournament.players_seed_list }

    it 'should initialize empty' do
      subject.instance_variable_get(:@list).size.should eql 0
    end

    describe 'when a single player is added' do
      before do
        @player = tournament.players.create
      end

      pending do
        it 'should contain that player' do
          tournament.players_seed_list
        end
      end
    end

  end
end
