module Github
  class IssueAggregate
    def initialize(github_client=nil)
      @github_client = github_client
    end

    # @return [Repo] Returns repos, each with a reference to the pull requests.
    def for_user(username)
      repos = @github_client.find_repos_for_user(username)
      repos += @github_client.find_repos_for_user_across_organizations(username)
    end
  end
end
