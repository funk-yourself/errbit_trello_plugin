require 'errbit_plugin'
require 'trello'

module ErrbitTrelloPlugin
  class IssueTracker < ErrbitPlugin::IssueTracker
    CLIENT_FIELDS = %w[developer_public_key member_token]
    REQUIRED_FIELDS = CLIENT_FIELDS + ['list_id']
    OPTIONAL_FIELDS = ['board_url']

    class << self
      def label
        'trello'
      end

      def note
        %q{You need to obtain your key and token <a href="https://trello.com/app-key" target="_blank">here</a>.
          The easiest way to get Trello List ID is to append ".json" to the url of your Trello board and search for the list by its name.}.html_safe
      end

      def fields
        (REQUIRED_FIELDS + OPTIONAL_FIELDS).map { |f| { f => {} } }.reduce(:merge)
      end

      def icons
        @icons ||= {
          create: [
            'image/png', ErrbitTrelloPlugin.read_static_file('trello_create.png')
          ],
          goto: [
            'image/png', ErrbitTrelloPlugin.read_static_file('trello_goto.png'),
          ],
          inactive: [
            'image/png', ErrbitTrelloPlugin.read_static_file('trello_inactive.png'),
          ]
        }
      end
    end

    def configured?
      options.slice(*REQUIRED_FIELDS).keys.size == REQUIRED_FIELDS.size
    end

    def errors
      REQUIRED_FIELDS.map { |field| [field, "is required"] unless options[field] }.compact
    end

    def create_issue(title, body, _)
      trello_client.create(:card, list_id: options['list_id'], name: title, desc: body).url
    end

    def url
      options['board_url']
    end

    private

    def trello_client
      @trello_client ||= Trello::Client.new(options.slice(*CLIENT_FIELDS).symbolize_keys)
    end
  end
end
