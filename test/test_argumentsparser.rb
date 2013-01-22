require 'test/unit'
require 'argumentsparser'

class ArgumentsParserTest < Test::Unit::TestCase

	def setup
		@parser =  JenkinsGrowler::ArgumentsParser.new
	end

	def test_should_parse_url_param
		options = @parser.parse(['-s','server url'])

		assert_equal("server url", options[:server_url], "Expected 'server url'")
	end

	def test_should_parse_jobs
		options = @parser.parse(['-s','server url', '-j' , "job1, job2"])

		assert_equal(['job1','job2'], options[:jobs], "Expected jobs 'job1' and 'job2'")
	end
end