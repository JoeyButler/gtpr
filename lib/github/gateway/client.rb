module Github
  class Gateway
    class Client
      attr_accessor :http_client

      def initialize(oauth_token, cache=Rails.cache)
        @http_client = Faraday.new(options) do |builder|
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use FaradayMiddleware::Mashify
          builder.use FaradayMiddleware::ParseJson
          builder.use FaradayMiddleware::OAuth2, oauth_token

          # If you are experiencing odd issues with the middleware, or everything
          # returns a response full of nil values, try deleting the cache.
          builder.use FaradayMiddleware::Caching, cache
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

      def find_issues_for_repo(full_repo_name)
        # GET /repos/:user/:repo/issues
        result = @http_client.get "/repos/#{full_repo_name}/issues"
        result.body.map do |pulls|
          Issue.new(pulls)
        end
      end

      def find_repos_for_user_across_organizations(username)
        orgs = find_organizations_for_user(username)
        repos = []
        orgs.map do |org|
          result = @http_client.get "/orgs/#{org.login}/repos"
          repos << result.body.map do |repo_attrs|
            Repo.new(repo_attrs)
          end
        end
        repos.flatten
      end

      def find_organizations_for_user(username)
        result = @http_client.get "/users/#{username}/orgs"
        result.body.map do |orgs|
          Organization.new(orgs)
        end
      end

      private

      def options
        {:url => 'https://api.github.com/'}
      end

      class Repo
        attr_reader :html_url, :full_name, :language, :private, :open_issues,
          :description
        attr_accessor :pulls
        def initialize(attrs)
          # E.g. https://github.com/livingsocial/rake-pipeline.git
          @html_url = attrs[:html_url]
          # E.g. mattmueller/koala
          @full_name = attrs[:full_name]
          @language = attrs[:language]
          @private = attrs[:private]
          @description = attrs[:description]
          @open_issues = attrs[:open_issues]
        end
      end

      class PullRequest
        attr_reader :issue_url, :title, :user_avatar_url, :user_login
        def initialize(attrs)
          @issue_url = attrs[:issue_url]
          @title = attrs[:title]
          if attrs[:user]
            @user_avatar_url = attrs[:user][:avatar_url]
            @user_login = attrs[:user][:login]
          end
        end
      end

      class Organization
        attr_reader :login
        def initialize(attrs)
          @login = attrs[:login]
        end
      end

      class Issue
        attr_reader :title, :user_login, :user_avatar_url, :labels, :pull_request_url
        def initialize(attrs)
          @title = attrs[:title]
          @labels = attrs[:labels].map {|l| l.name}.join(", ")
          @pull_request_url = attrs[:pull_request][:html_url]
          if attrs[:user]
            @user_avatar_url = attrs[:user][:avatar_url]
            @user_login = attrs[:user][:login]
          end
        end
      end
    end
  end
end
