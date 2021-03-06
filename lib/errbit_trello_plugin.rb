require 'errbit_trello_plugin/version'
require 'errbit_trello_plugin/issue_tracker'

module ErrbitTrelloPlugin
  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.read_static_file(file)
    File.read(File.join(self.root, 'static', file))
  end
end

ErrbitPlugin::Registry.add_issue_tracker(ErrbitTrelloPlugin::IssueTracker)
