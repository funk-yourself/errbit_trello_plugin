module ErrbitTrelloPlugin
  class IssueTracker < ErrbitPlugin::IssueTracker
    CLIENT_FIELDS = %w[developer_public_key developer_public_token]
    REQUIRED_FIELDS = CLIENT_FIELDS + ['list_id']

    class << self
      def label
        'trello'
      end

      def note
        'note'
      end

      def fields
        REQUIRED_FIELDS.map { |f| { f => {} } }.reduce(:merge)
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
      REQUIRED_FIELDS.reduce([]) do |errors, field|
        errors.tap { |e| e << [field, "is required"] unless options[field] }
      end
    end

    def create_issue(title, body, user: {})
      trello_client.create(:card, list_id: options['list_id'], name: title, body: body).url
    end

    def close_issue(issue_link, user = {})
      # Close the issue! (Perhaps using the passed in issue_link url to identify it.)
    end

    def url
      'http://trello.com'
    end

    private

    def trello_client
      @trello_client ||= Trello::Client.new(options.slice(*CLIENT_FIELDS))
    end
  end
end
