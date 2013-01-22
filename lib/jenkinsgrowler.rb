#!/usr/bin/ruby
 
require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'date'
 
$ciBaseUrl = 'http://ci.motechproject.org' #URL of your jenkins CI
$jobs = ['Ananya-Kilkari','Ananya-Reports','Ananya-Kilkari-Smoke'] # add all the jobs to be monitored in this list
$interval = 60  # time in seconds - this script checks for build activity in the mentioned interval
 
$jobRuns = Hash.new
 
def last_build_output(job)
  url = URI.parse("#$ciBaseUrl")
  res = Net::HTTP.start(url.host, url.port) { |http|
    http.get("/job/#{job}/lastBuild/api/json")
  }
 
  JSON.parse res.body
end
 
 
def changed_recently(buildTime, job)
  buildRunTime = DateTime.strptime("#{buildTime}+0530", '%Y-%m-%d_%H-%M-%S%z')
 
 
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
 
  %x[ /usr/local/bin/growlnotify -t "#{result}" -m "#{description}\n#{comments}" ]
end
 
while true do
  $jobs.each do |job|
    build_status job
  end
 
  sleep $interval 
end
