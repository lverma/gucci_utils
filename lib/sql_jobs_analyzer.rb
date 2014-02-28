require 'date'

module SqlJobsAnalyzer
  extend self
  
  @dev_envs = %W[luca alex ae indrit dario gregory psingh sumit varun atif francesco alessandra stefano marco costajob video atul aayush giuseppe scandi support wiretransfer australia search europe sopra]
  @qa_envs  = (1..13).map { |n| "qa#{n}" }
  SQL_FILE  = 'jobs_analyzer.sql'
  TODAY     = Date.today.strftime("%Y-%m-%d")
  
  def exec(starting_from)
    generate_sql(starting_from)
    save_to_file
  end
  
  private
  
  def generate_sql(starting_from)
    starting_from ||= TODAY
    @sql = "SET @starting_from = '#{starting_from}'; "
    selects = []
    (@qa_envs + @dev_envs).each do |env|
      selects << "SELECT 'gold_#{env}' AS db_name, pb.created_at AS started_on, pb.description FROM gold_#{env}.publishing_jobs pb WHERE pb.created_at >= @starting_from"
    end
    @sql += selects.join(' UNION ')
    @sql += ' ORDER BY db_name, started_on DESC;'
  end
  
  def save_to_file
    File.open("./#{SQL_FILE}", 'w') do |f|
      f << @sql
    end
  end
end