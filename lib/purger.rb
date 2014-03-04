require 'fileutils'

module Purger
  extend self
  
  @published_paths = %w(public public-m)
  @sites = %w(ae at au be bg ca-en ca-fr ch cn cn-en cz de dk es fi fr hu ie int it jp kr nl no pl pt ro se si tr uk us)
  @dirs_count = 0
  
  attr_reader :dirs_count
  
  def exec!(proj_dir)
    @published_paths.each do |path|
      @sites.each do |site|
        if File.exists?((published_dir = File.join(proj_dir, path, site)))
          yield site
          FileUtils.rm_rf published_dir
          @dirs_count += 1
        end
      end
    end
  end
end