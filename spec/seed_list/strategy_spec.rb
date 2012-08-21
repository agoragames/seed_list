require 'spec_helper'

describe SeedList::Strategy do
  before :all do
    @tournament = FactoryGirl.create :tournament
    @players = FactoryGirl.create_list :player, 4, tournament: @tournament
  end

  describe SeedList::Strategy::Knockout do
    # Stub shuffle to reverse to avoid basing spec success on a random value
    before { @players.stub(:shuffle) { @players.reverse } }

    describe 'seed' do
      subject{ SeedList::Strategy::Knockout.new(@players).seed }
      it('should return shuffled players') { subject.should eql @players.reverse }
    end
  end

  describe SeedList::Strategy::Amateur do
    describe 'seed' do
      subject{ SeedList::Strategy::Amateur.new(@players).seed }
      it 'should return the players in ascending order' do
        subject[0].seed.should eql 1
        subject[1].seed.should eql 2
        subject[2].seed.should eql 3
        subject[3].seed.should eql 4
      end
    end
  end

  describe SeedList::Strategy::Playoff do
    describe 'seed' do
      subject{ SeedList::Strategy::Playoff.new(@players).seed }
      it 'should match the best player with the worst player' do
        subject[0].seed.should eql 1
        subject[1].seed.should eql 4
      end

      it 'should match the second best player with the second worst player' do
        subject[2].seed.should eql 2
        subject[3].seed.should eql 3
      end
    end
  end

  describe SeedList::Strategy::MLGPlayoff do
    before :all do
      @players = FactoryGirl.create_list :player, 16
    end

    describe 'seed' do
      subject{ SeedList::Strategy::MLGPlayoff.new(@players).seed }
      pending 'MLGPlayoff algorithm not yet implemented' do
        it 'should match the 16 player sample provided by John Nelson' do
          subject[0].seed.should eql 0
          subject[1].seed.should eql 15
          subject[2].seed.should eql 8
          subject[3].seed.should eql 7
          subject[4].seed.should eql 4
          subject[5].seed.should eql 11
          subject[6].seed.should eql 12
          subject[7].seed.should eql 3
          subject[8].seed.should eql 2
          subject[9].seed.should eql 13
          subject[10].seed.should eql 10
          subject[11].seed.should eql 5
          subject[12].seed.should eql 6
          subject[13].seed.should eql 9
          subject[14].seed.should eql 14
          subject[15].seed.should eql 1
        end
      end
    end
  end

end
