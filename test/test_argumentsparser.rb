require 'test/unit'
require 'argumentsparser'

class ArgumentsParserTest < Test::Unit::TestCase

	def setup
		@parser =  JenkinsGrowler::ArgumentsParser.new
	end

	def test_should_parse_jobs_and_server_url
		options = @parser.parse(['-s','server url', '-j' , "job1, job2"])

		assert_equal(['job1','job2'], options[:jobs], "Expected jobs 'job1' and 'job2'")
		assert_equal("server url", options[:server_url], "Expected 'server url'")
	end

	def test_should_parse_time_interval
		options = @parser.parse(['-s','server url', '-j', 'job','-i' , '50'])
	
		assert_equal(50, options[:poll_interval])
	end

	def test_default_time_interval_should_be_60
		options = @parser.parse(['-s','server url', '-j' , "job1, job2"])

		assert_equal(60, options[:poll_interval])
	end
end