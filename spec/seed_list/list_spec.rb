require 'spec_helper'

describe SeedList::List do

  it 'can be initialized empty' do
    list = SeedList::List.new
    list.instance_variable_get(:@list).size.should eql 0
  end

  it 'can be initialized with values' do
    list = SeedList::List.new(1,2,3)
    list.instance_variable_get(:@list).size.should eql 3
  end

  it 'can be appended to' do
    list = SeedList::List.new(1,2,3)
    list.push(4)
    list.instance_variable_get(:@list).should eql [1,2,3,4]
  end

  it 'can be prepended to' do
    list = SeedList::List.new(1,2,3)
    list.unshift(4)
    list.instance_variable_get(:@list).should eql [4,1,2,3]
  end

  it 'can move the last element to the beginning' do
    list = SeedList::List.new(1,2,3)
    list.move(3, 1)
    list.instance_variable_get(:@list).should eql [3,1,2]
  end

  it 'can move the first element to the end' do
    list = SeedList::List.new(1,2,3)
    list.move(1, 3)
    list.instance_variable_get(:@list).should eql [2,3,1]
  end

  it 'can move a middle element back 2 places' do
    list = SeedList::List.new(1,2,3,4,5)
    list.move(4, 2)
    list.instance_variable_get(:@list).should eql [1,4,2,3,5]
  end

  it 'can move a middle element forward 3 places' do
    list = SeedList::List.new(1,2,3,4,5,6)
    list.move(2, 5)
    list.instance_variable_get(:@list).should eql [1,3,4,5,2,6]
  end

  it 'can delete the first element' do
    list = SeedList::List.new(1,2,3)
    list.delete(1)
    list.instance_variable_get(:@list).should eql [2,3]
  end

  it 'can delete the last element' do
    list = SeedList::List.new(1,2,3)
    list.delete(3)
    list.instance_variable_get(:@list).should eql [1,2]
  end

  it 'can delete the middle element' do
    list = SeedList::List.new(1,2,3)
    list.delete(2)
    list.instance_variable_get(:@list).should eql [1,3]
  end

  it 'can find an element by id' do
    list = SeedList::List.new(1,2,6,3,4,5)
    list.find(6).should eql 3
  end

end
