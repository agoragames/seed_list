require 'spec_helper'

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

      describe 'the tournament' do
        subject { tournament }
        it 'should contain that player after reload' do
          subject.reload.players_seed_list.instance_variable_get(:@list).should include(@player.id)
        end
      end

      describe 'the player' do
        subject { @player }
        it 'should respond with a seed number of 1' do
          subject.seed.should eql 1
        end
      end
    end


  end

  describe 'when 4 players exist' do
    before { 4.times { tournament.players.create } }

    describe '#players_seed_list' do
      subject { tournament.reload.players_seed_list }

      it 'should contain 4 players' do
        subject.instance_variable_get(:@list).size.should eql 4
      end
    end

    describe 'the first player' do
      subject { tournament.players.first }

      it 'should have a seed number of 1' do
        subject.seed.should eql 1
      end

      describe 'when moved to the 4th position' do
        before { tournament.players.first.seed = 4 }

        describe '@list' do
          subject { tournament.reload.players_seed_list.instance_variable_get(:@list) }

          it 'reflect the new seed order' do
            subject.should eql [
              tournament.players[1].id,
              tournament.players[2].id,
              tournament.players[3].id,
              tournament.players[0].id
            ]
          end
        end
      end

    end

  end
end
