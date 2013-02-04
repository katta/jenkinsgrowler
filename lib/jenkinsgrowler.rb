require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'date'
require 'argumentsparser'

options = JenkinsGrowler::ArgumentsParser.new.parse(ARGV)

$ciBaseUrl = options[:server_url]
$jobs = options[:jobs]
$interval = options[:poll_interval]
$username = options[:username]
$password = options[:password]
$timezone = options[:timezone]
 
$jobRuns = Hash.new
 
def last_build_output(job)
  uri = URI.parse("#{$ciBaseUrl}/job/#{job}/lastBuild/api/json")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  if ($username !=nil && $password != nil) then
    request.basic_auth($username, $password)
  end

  res = http.request(request)
  if(res.is_a? Net::HTTPClientError) then
    puts "Error: Not able to read the job status, failed with error [#{res.message}]"
    puts"   Make sure the basic authorization credentials are provided, if the site is protected or the job names given are right."
    exit
  end

  JSON.parse res.body
end
 
 
def changed_recently(buildTime, job)
  buildRunTime = DateTime.strptime("#{buildTime}#{$timezone}", '%Y-%m-%d_%H-%M-%S%z')
  
  if $jobRuns[job] == nil then
    $jobRuns[job] = buildRunTime
    return false
  end
 
  if buildRunTime > $jobRuns[job] then
    $jobRuns[job] = buildRunTime
    return true
  end
  return false
end
 
 
def build_status(job)
  buildOutput = last_build_output job  
  building = buildOutput['building']
  buildTime = buildOutput['id']
  duration = buildOutput['duration']
 
  if building or !changed_recently(buildTime, job) then
    return
  end
 
  result = buildOutput['result']
  description = buildOutput['fullDisplayName']
  url = buildOutput['url']
 
  comments = ''
  buildOutput['changeSet']['items'].each do |item|
    comments += item['comment']
  end
 
  %x[ growlnotify -t "#{result}" -m "#{description}\n#{comments}" ]
end
 
while true do
  $jobs.each do |job|
    build_status job
  end
 
  sleep $interval 
end
