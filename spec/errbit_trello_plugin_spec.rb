require 'spec_helper'
require 'errbit_trello_plugin'

describe ErrbitTrelloPlugin do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end
