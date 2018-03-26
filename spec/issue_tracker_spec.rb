require 'spec_helper'
require 'errbit_trello_plugin'

describe ErrbitTrelloPlugin::IssueTracker do
  let(:tracker) { described_class.new('developer_public_key' => 'key', 'member_token' => 'token', 'list_id' => 'list_id', 'board_url' => 'board_url') }

  describe '.label' do
    subject { described_class.label }

    it { is_expected.to eq('trello') }
  end

  describe '.fields' do
    subject { described_class.fields }

    it { is_expected.to eq('developer_public_key' => {}, 'member_token' => {}, 'list_id' => {}, 'board_url' => {}) }
  end

  describe '#configured?' do
    subject { tracker.configured? }

    context 'when all fields are present' do
      it { is_expected.to eq(true) }
    end

    context 'when some fields are missing' do
      let(:tracker) { described_class.new('developer_public_key' => 'key', 'list_id' => 'list_id') }

      it { is_expected.to eq(false) }
    end
  end

  describe '#errors' do
    subject { tracker.errors }

    context 'when all fields are present' do
      it { is_expected.to eq([]) }
    end

    context 'when some fields are missing' do
      let(:tracker) { described_class.new('developer_public_key' => 'key', 'list_id' => 'list_id') }

      it { is_expected.to eq([['member_token', 'is required']]) }
    end
  end

  describe '#create_issue' do
    subject { tracker.create_issue('title', 'body', nil) }

    let(:trello_client) { double }

    before do
      allow(trello_client).to receive(:create).with(:card, list_id: 'list_id', name: 'title', desc: 'body').and_return(double(url: 'url'))
      allow(tracker).to receive(:trello_client).and_return(trello_client)
    end

    it { is_expected.to eq('url') }
  end

  describe '#url' do
    subject { tracker.url }

    it { is_expected.to eq('board_url') }
  end
end
