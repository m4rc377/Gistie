class GistRepo
  include Rugged
  include RepoWriter

  attr_reader :path

  def initialize(path)
    @path = path
  end

  delegate :lookup, :to => :repo

  def repo
    @repo ||= Repository.new(@path)
  end

  def head
    repo.head.target
  end

  def self.init_named_repo(name, bare = true)
    Repository.init_at(repo_path(name), bare)
  end

  def self.named(name)
    new(repo_path(name))
  end

  def self.repo_path(name, root = Rails.configuration.repo_root)
    (root + ( name + ".git/")).to_s
  end

  def log(opts = {})
    @log ||= RepoLog.new(repo, opts)
  end

  def tree(head)
    @tree ||= RepoTree.new(repo, head)
  end
end
