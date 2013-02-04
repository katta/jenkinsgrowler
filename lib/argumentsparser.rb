require 'optparse'

module JenkinsGrowler

  class ArgumentsParser

    def parse(args)
      options = {}

      optparse = OptionParser.new do |opts|
        opts.banner = "Usage: jenkinsgrowler [options]"

        options[:server_url] = nil
        options[:jobs] = []
        options[:poll_interval] = 60
        options[:username] = nil
        options[:password] = nil
        options[:timezone] = "+0530"


        opts.on("-s","--server SERVER_URL","URL of the jenkins server") do |url|
          options[:server_url] = url
        end

        opts.on("-j","--jobs JOBS","Comma separated jobs names") do |jobs|
          if (jobs.length > 0) then
            jobs.split(',').each do |job|
              options[:jobs] << job.strip()
            end
          end
        end

        opts.on("-i","--interval INTEVAL","Polling interval in seconds. Default (60 seconds)") do |interval|
          options[:poll_interval] = interval.to_i
        end

        opts.on("-u","--user USERNAME","Username for basic authentication") do |username|
          options[:username] = username
        end

        opts.on("-p","--password PASSWORD","Password for basic authentication") do |password|
          options[:password] = password
        end

        opts.on("-t","--timezone TIMEZONE", "Server's timezone. Default (+0530)") do |timezone|
          options[:timezone] = timezone
        end

        opts.on( "-h", "--help", "Displays help message" ) do
          puts opts
          exit
        end
      end

      optparse.parse!(args)

      if(options[:server_url] == nil || options[:jobs].length == 0)
        puts optparse
        exit(-1)
      end

      options
    end
  end
end
