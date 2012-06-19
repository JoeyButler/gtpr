module Github
  class Gateway
    def initialize
      @http_client = Faraday.new(options) do |builder|
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use FaradayMiddleware::Mashify
        builder.use FaradayMiddleware::ParseJson
        # TODO: figure out why caching doesn't work
        # builder.use FaradayMiddleware::Caching, Rails.cache
        builder.adapter Faraday.default_adapter
      end
    end

    def find_repos_for_user(username)
      result = @http_client.get "/users/#{username}/repos"
      result.body.map do |repo_attrs|
        Repo.new(repo_attrs)
      end
    end

    # @param string full_repo_name Format as :user/:repo. E.g. mattmueller/foursquare2
    def find_pulls_for_repo(full_repo_name)
      result = @http_client.get "/repos/#{full_repo_name}/pulls"
      result.body.map do |pulls|
        PullRequest.new(pulls)
      end
    end

    private

    def options
      {:url => 'https://api.github.com/'}
    end

    class Repo
      attr_reader :url, :full_name, :language
      attr_accessor :pulls
      def initialize(attrs)
        # E.g. https://api.github.com/repos/mattmueller/koala
        @url = attrs[:url]
        # E.g. mattmueller/koala
        @full_name = attrs[:full_name]
        @language = attrs[:language]
      end
    end

    class PullRequest
      attr_reader :issue_url, :title, :user_avatar_url, :login
      def initialize(attrs)
        @issue_url = attrs[:issue_url]
        @title = attrs[:title]
        if attrs[:user]
          @user_avatar_url = attrs[:user][:avatar_url]
          @user_login = attrs[:user][:login]
        end
      end
    end
  end
end

