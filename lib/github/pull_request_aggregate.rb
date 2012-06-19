
module Github
class PullRequestAggregate
  def initialize(pr_finder=nil)
    @pr_finder = pr_finder || lambda { ::Github::Gateway.new }.call
  end

  # @return [Repo] Returns repos, each with a reference to the pull requests.
  def all_pulls_across_all_repos_for_user(username)
    repos = @pr_finder.find_repos_for_user(username)
    repos.map do |repo|
      repo.pulls = @pr_finder.find_pulls_for_repo(repo.full_name)
      repo
    end
  end
end
end
