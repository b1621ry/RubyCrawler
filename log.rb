#!/usr/bin/env ruby
require 'date'
# regular expression for apache common log format
# host ident user time request status bytes
re = /^(\S+) (\S+) (\S+) \[(.*?)\] "(.*?)" (\d+) (\d+|-)/
timebins = Hash.new([0, 0])
count = parsed = 0

ARGF.each_line do |line|
  count += 1
  if re.match(line)
  host, ident, user, time, request, status, bytes = $~.captures
  # ignore if the request is not "GET"
    next unless request.match(/GET\s.*/)
  # ignore if the status is not success (2xx)
    next unless status.match(/2\d{2}/)
    parsed += 1
  # parse timestamp
  
  ts = DateTime.strptime(time, '%d/%b/%Y:%H:%M:%S')
  # create the corresponding key for 5-minutes timebins
  rounded = sprintf("%02d", ts.min.to_i / 5 * 5)
  key = ts.strftime("%Y-%m-%dT%H:#{rounded}")
  # count by request and byte
  timebins[key] = [timebins[key][0] + 1, timebins[key][1] + bytes.to_i]
else
  # match failed
  $stderr.puts("match failed at line #{count}: #{line.dump}")
end
end
timebins.sort.each do |key, value|
puts "#{key} #{value[0]} #{value[1]}"
end



