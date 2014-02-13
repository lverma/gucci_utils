require File.join(File.dirname(__FILE__), 'utils.rb')
include Utils

namespace :git do
  class GitException < StandardError; end
  PROJ_DIR = File.join(ENV['HOME'], 'Sites')
  FILE_DIR = File.join(ENV['HOME'], 'Sites')
  
  desc 'Set base directory: i.e rake git:basedir basedir=/my/base/dir'
  task :basedirs do
    @projdir = ENV['projdir'] || PROJ_DIR
    @filedir = ENV['filedir'] || FILE_DIR
  end
  
  desc 'Provide the GIT repository: i.e. rake git:repos'
  task :repo => :basedirs do
    repo = ask 'Provide a valid GIT repository:'.bold.grey
    puts "Using #{repo} repo...".bold.yellow
    @repo_path = File.join(@projdir, repo.to_s)
  end
  
  desc 'Load the branches from an external file and/or by spcifing a specific one: i.e. rake git:branches file=aggregate branch=add_this_one'
  task :branches => :basedirs do
    @branches = []
    file = ENV['file']
    if file
      branches_file = File.join(@filedir, file)
      print_spacer 'Loading branches file...'.bold.yellow
      @branches += File.foreach(branches_file).map(&:strip)
    end
    branch = ENV['branch']
    @branches << branch if branch
    raise GitException, "No branches loaded!".bold.red if @branches.empty?
    puts "Successfully loaded #{@branches.count} branch/es:".bold.green
    @branches.each { |b| puts b }
  end
  
  desc 'Aligns specified branch with origin: i.e. rake git:align branch=my_branch'
  task :align => :repo do
    branch = ENV['branch'] || 'master'
    print_spacer "Aligning branch: #{branch}".bold.magenta
    Dir.chdir @repo_path do
      puts "Checking-out the branch..."
      %x[git checkout #{branch}]
      puts "Pulling it..."
      %x[git pull]
    end
  end
  
  desc 'Remove the specified branch/branches locally and from origin: i.e. rake git:remove file=remove'
  task :remove => [:repo, :branches] do |t, args|
    Dir.chdir @repo_path do
      puts "Checking-out to master..."
      %x[git checkout master]
      @branches.each do |branch|
        raise GitException, "Cannot remove master!".bold.red if branch == 'master'
        print_spacer "Removing branch: #{branch}".bold.magenta
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
  
  desc 'Rebase the specified branches with master with options: i.e rake git:rebase file=rebase options=i'
  task :rebase => [:align, :branches] do
    options = ENV['options'] ? "-#{ENV['options']}" : ""
    Dir.chdir @repo_path do
      @branches.each do |branch|
        ack = true
        print_spacer "Rebasing branch: #{branch}".bold.magenta
        puts 'Checking-out...'
        %x[git checkout #{branch}]
        puts "Pulling it..."
        %x[git pull origin #{branch}]
        puts 'Rebasing with master...'
        %x[git rebase #{options} origin/master]
        if %w(rebase-merge rebase-apply).any? { |name| File.exists?(File.join(@repo_path, '.git', name)) }
          ack = false
          puts 'Halting unfinished rebase...'.bold.red
          %x[git rebase --abort]
        else
          puts 'Pushing to origin...'
          %x[git push origin #{branch} --force]
        end
        puts 'Returning to master...'
        %x[git checkout master]
        puts 'Remove local branch...'
        %x[git branch -D #{branch}]
        puts 'Rebased successfully!'.bold.green if ack
      end
    end
  end
  
  desc 'Aggregate specified branches into a single one: i.e. rake git:aggregate file=aggregate'
  task :aggregate => [:align, :branches] do
    release = Time.new.strftime("rb_%Y-%m-%d")
    temp = "temp_#{release}"
    Dir.chdir @repo_path do
      %x[git branch #{release}]
      @branches.each do |branch|
        print_spacer "Aggregating branch: #{branch}".bold.magenta
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
    print_spacer "Release branch created: #{release}".bold.yellow
  end
    
end