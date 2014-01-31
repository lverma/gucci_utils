require File.join(File.dirname(__FILE__), 'utils.rb')
include Utils

namespace :git do
  class GitException < StandardError; end
  @basedir = File.join(ENV['HOME'], 'Sites')
  
  desc 'Set base directory'
  task :basedir do
    @basedir ||= ENV['basedir']
    puts @basedir
  end
  
  desc 'Choose one of the available GIT repositiories'
  task :repos => :basedir do
    repo = ENV['repo']
    default_repos = %w[oro chime]
    default_repos << repo if repo
    default_repos = Hash[(0...default_repos.size).zip default_repos]
    choose(:msg => 'Choose repository', :choices => default_repos, :multi => false) do |repo|
      repo = default_repos[repo.to_i]
      puts 'Using ' + repo.to_s.bold.magenta + ' repo...'.normal
      @repo_path = File.join(@basedir, repo.to_s)
    end
  end
  
  desc 'Load the branches from an external file and/or by spcifing a specific one: i.e. rake git:branches branches=aggregate branch=add_this_one'
  task :branches => :basedir do
    @branches = []
    branches = ENV['branches']
    if branches
      branches_file = File.join(@basedir, branches)
      print_spacer 'Loading branches file...'.bold
      @branches += File.foreach(branches_file).map(&:strip)
    end
    branch = ENV['branch']
    @branches << branch if branch
    raise GitException, "No branches loaded!".bold.red if @branches.empty?
    puts "Successfully loaded " + @branches.count.to_s.bold.yellow + " branch/es:".normal
    @branches.each { |b| puts b }
  end
  
  desc 'Aligns specified branch with master'
  task :align => :repos do
    branch = ENV['branch'] || 'master'
    print_spacer "Aligning branch: #{branch.bold}"
    Dir.chdir @repo_path do
      puts "Checking-out the branch..."
      %x[git checkout #{branch}]
      puts "Pulling it..."
      %x[git pull]
    end
  end
  
  desc 'Remove the specified branch/branches locally and from origin: i.e. rake git:remove branches=removing'
  task :remove => [:repos, :branches] do |t, args|
    Dir.chdir @repo_path do
      puts "Checking-out to master..."
      %x[git checkout master]
      @branches.each do |branch|
        raise "Cannot remove master!".bold.red if branch == 'master'
        print_spacer "Removing branch: #{branch.bold.yellow}"
        confirm('Remove local branch') do
          puts 'Removing local branch...'
          %x[git branch -D #{branch}]
        end
        confirm('Remove remote branch') do
          puts 'Removing remote branch...'
          %x[git push origin :#{branch}]
        end
       end
     end
  end
  
  desc 'Rebase the specified branches with master with options: i.e rake git:rebase branches=rebasing options=i'
  task :rebase => [:align, :branches] do
    options = ENV['options'] ? "-#{ENV['options']}" : ""
    Dir.chdir @repo_path do
      @branches.each do |branch|
        print_spacer "Working on branch: #{branch.bold}"
        puts 'Checking-out...'
        %x[git checkout #{branch}]
        puts "Pulling it..."
        %x[git pull origin #{branch}]
        puts 'Rebasing with master...'
        %x[git rebase #{options} origin/master]
        if %w(rebase-merge rebase-apply).any? { |name| File.exists?(File.join(@repo_path, '.git', name)) }
          puts 'Halting unfinished rebase...'.red.bold
          %x[git rebase --abort]
        else
          puts 'Pushing to origin...'
          %x[git push origin #{branch} --force]
        end
        puts 'Returning to master...'
        %x[git checkout master]
        puts 'Remove local branch...'
        %x[git branch -D #{branch}]
      end
    end
  end
  
  desc 'Aggregate specified branches into a single one: i.e. rake git:aggregate branches=aggregating'
  task :aggregate => [:align, :branches] do
    release = Time.new.strftime("rb_%Y-%m-%d")
    temp = "temp_#{release}"
    Dir.chdir @repo_path do
      print_spacer "Creating release branch: #{release.bold}"
      %x[git branch #{release}]
      @branches.each do |branch|
        print_spacer "Working on branch: #{branch.bold}"
        puts 'Create temp branch...'
        %x[git checkout -b #{temp} origin/#{branch} --no-track]
        puts 'Rebasing with master...'
        %x[git rebase origin/master]
        puts 'Rebasing with release branch...'
        %x[git rebase #{release}]
        puts 'Checking out release branch...'
        %x[git checkout #{release}]
        puts 'Merging with temp branch...'
        %x[git merge #{temp}]
        puts 'Deleting temp branch...'
        %x[git branch -d #{temp}]
      end      
    end
  end
    
end