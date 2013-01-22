require 'optparse'

module JenkinsGrowler

  class ArgumentsParser

    def parse(args)
      options = {}

      optparse = OptionParser.new do |opts|
        opts.banner = "Usage: jenkinsgrowler [options]"

        options[:server_url] = nil
        options[:jobs] = []
        options[:poll_intervlaviews] = 60

        opts.on("-s","--server SERVER_URL","URL of the jenkins server") do |url|
          options[:server_url] = url 
        end

    		opts.on("-j","--jobs JOBS","Comma separated jobs names") do |jobs|
          if (jobs.length > 0) then
    			   options[:jobs] = jobs.split(',')
             options[:jobs] = options[:jobs].each{ |job| job.strip() }
          end
    		end 

        opts.on( "-h", "--help", "Displays help message" ) do
          puts opts
          exit
        end
      end
      
      optparse.parse!(args)

      if(options[:server_url] == nil)
        puts optparse
        exit(-1)
      end

      options
    end
  end
end
