require File.join(File.dirname(__FILE__), 'utils.rb')
include Utils

namespace :git do
  
  desc 'Choose one of the available GIT repositiories'
  task :choose_repo do
    repos = {
      1 => :oro,
      2 => :chime
    }
    choose('Choose repository', repos, false) do |repo|
      @repo = repos[repo.to_i]
      puts 'Using '.bold + @repo.to_s.magenta + ' repo...'.bold
      @repo_path = File.join(File.dirname(__FILE__), @repo.to_s)
    end
  end
  
  # Load the branches that need to be rebased by:
  # 1. looking for a file specifying the branches and reading it (as default a "branches" file in the same directory as this script)
  # 2. splitting the file content on new lines and obtaining a stripped array
  # 3. save the array into a class variable
  #
  # The branch names must be placed into the file by placing tham on different lines, as this:
  # > branch_name_1
  # > branch_name_2
  # > branch_name_3
  # > ...
  desc 'Load the to-be-rebased branches file and store the results into an array'
  task :load_branches, :filename do |t, args|
    begin
      print_spacer 'Loading branches file...'.bold
      @@branches ||= File.foreach(args.filename).map(&:strip)
      puts "Successfully loaded #{@@branches.count} branches:"
      @@branches.each { |b| puts b }
    rescue => e
      print_e e
    end
  end
  
  # Align to the specified branch by:
  # 1. entering the project folder
  # 2. checking-out specified branch
  # 3. pulling changes to local repositry 
  #
  # Call it without arguments to align to master branch:
  # > rake git:align      
  # Or by explicitely specifying a branch name:
  # rake git:align[branch_name]
  desc 'Aligns to the specified branch'
  task :align, [:branch] => :choose_repo do |t, args|
    args.with_defaults(:branch => 'master')
    print_spacer "Aligning to branch: #{args.branch.bold}"
    Dir.chdir @repo_path do
      puts "Checking-out the branch..."
      %x[git checkout #{args.branch}]
      puts "Pulling changes..."
      %x[git pull]
    end
  end
  
  # Remove the specified branch both from local and (optionally) origin by:
  # 1. checking out to master
  # 2. entering the project folder
  # 3. asking for the removal of the specified branch name from local repository
  # 4. if the "r" option i specified, asking for the removal of specified branch name from origin
  #
  # Call it by explicitely specifying a branch name:
  # rake git:remove[branch_name]
  #
  # Load branches to remove from file:
  # rake git:remove
  #
  # Specify 'r' option to remove branch from remote origin:
  # rake git:remove r=1
  desc 'Remove the specified branch both from local and origin'
  task :remove, [:branch] => :choose_repo do |t, args|
    begin
      unless args.branch
        branches_file = ENV['file'] ? ENV['file'] : 'removing'
        Rake::Task['git:load_branches'].invoke(branches_file)
      else
        @@branches = [args.branch]  
      end
      Dir.chdir @repo_path do
        puts "Checking-out to master..."
        %x[git checkout master]
        @@branches.each do |b|
          raise "Cannot remove master branch" if b == 'master'
          print_spacer "Removing branch: #{b.bold}"
          confirm('Remove local branch') do
            puts 'Removing local branch...'
            %x[git branch -D #{b}]
          end
          if ENV['r']
            confirm('Remove remote branch') do
              puts 'Removing remote branch...'
              %x[git push origin :#{b}]
            end
          end
        end
      end
    rescue => e
      print_e e
    end
  end
  
  # Rebase a set of branches into the master one by:
  # 1. aligning to master branch
  # 2. if no branch is specified pre-load a list of them from local file (see the git:load_branches task for detail)
  # 3. checking-out current branch
  # 4. pulling changes from remote
  # 5. executing rebase with master (interactive if option is specified, see below)
  # 6. pushing the branch to origin
  # 7. if the ".git/rebase-*" folders exists, abort current rebasing
  # 8. checking out master
  # 9. removing local branch
  #
  # Call it without arguments to load the file specifying the branches to rebase:
  # > rake git:rebase      
  #
  # Or by explicitely spcifying a branch name:
  # > rake git:rebase[branch_name]
  #
  # Specify 'i' option for interactive rebase:
  # > rake git:rebase i=1
  #
  # Specify file name to select branches from (default is './rebasing'):
  # > rake git:rebase bf=rebasing_ext
  #
  # WARNING: you have to resolve your conflict with master before to call the rebase command!
  desc 'Execute the GIT rebase command on a set of branches'
  task :rebase, [:branch] => :choose_repo do |t, args|
    Rake::Task['git:align'].execute
    unless args.branch
      branches_file = ENV['file'] ? ENV['file'] : 'rebasing'
      Rake::Task['git:load_branches'].invoke(branches_file)
    else
      @@branches = [args.branch]  
    end
    interactive = ENV['i'] ? '-i' : ''
    Dir.chdir @repo_path do
      @@branches.each do |b|
        print_spacer "Working on branch: #{b.bold}"
        puts 'Checking-out...'
        %x[git checkout #{b}]
        puts "Pulling changes..."
        %x[git pull origin #{b}]
        puts 'Rebasing with master...'
        %x[git rebase #{interactive} origin/master]
        if %w(rebase-merge rebase-apply).any? { |name| File.exists?(File.join(@repo_path, '.git', name)) }
          puts 'Halting unfinished rebase...'.red.bold
          %x[git rebase --abort]
        else
          puts 'Pushing to origin...'
          %x[git push origin #{b} --force]
        end
        puts 'Returning to master...'
        %x[git checkout master]
        puts 'Remove local branch...'
        %x[git branch -D #{b}]
      end
    end
  end
  
  # Aggregate a set of branches into the current release branch:
  # 1. create current release branch by using current time: rb_yyyy_mm_dd
  # 2. if no branch is specified pre-load a list of them from local file (see the git:load_branches task for detail)
  # 3. creating e temp branch by checking-out current branch
  # 4. executing interactive rebase with master
  # 5. executing interactive rebase of release branch with master 
  # 6. checking out release branch
  # 7. merging temp branch with the release one
  # 9. deleting temp branch locally
  # 10. rebasing the release branch by calling the appropriate task
  #
  # Call it without option to load the file specifying the branches to aggregate:
  # > rake git:aggergate
  #
  # Specify the 'i' option for interactive rebase:
  # > rake git:aggergate i=1
  #
  # WARNING: you have to resolve your conflict with master before to call the rebase command!
  desc 'Aggregate a set of branches into a single branch used for release'
  task :aggregate => :choose_repo do
    Rake::Task['git:align'].execute
    branches_file = ENV['file'] ? ENV['file'] : 'aggregating'
    Rake::Task['git:load_branches'].invoke(branches_file)
    release = Time.new.strftime("rb_%Y-%m-%d")
    temp = "temp_#{release}"
    interactive = ENV['i'] ? '-i' : ''
    Dir.chdir @repo_path do
      print_spacer "Creating release branch: #{release.bold}"
      %x[git branch #{release}]
      @@branches.each do |b|
        print_spacer "Working on branch: #{b.bold}"
        puts 'Create temp branch...'
        %x[git checkout -b #{temp} origin/#{b} --no-track]
        puts 'Rebasing with master...'
        %x[git rebase #{interactive} origin/master]
        puts 'Rebasing with release branch...'
        %x[git rebase #{interactive} #{release}]
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