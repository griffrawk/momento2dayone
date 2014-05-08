#!/usr/bin/env ruby1.9

require File.dirname(__FILE__) + "/date_format"
require File.dirname(__FILE__) + "/day"
require File.dirname(__FILE__) + "/entry"
require File.dirname(__FILE__) + "/input"
require "open3"
include Input

@days = []

@current_entry = nil
@current_day   = nil

ARGF.each_line do |line|
  # line = process_line(line)
  # Date line in the regexp followed by CRLF
  if line =~ /^(#{ Day::DAYS }) (\d+) (#{ Day::MONTHS }) (#{ Day::YEARS })\r\n$/
    @current_entry = Entry.new(nil, nil, [])
    @current_day   = Day.new(Date.parse("#{$3} #{$2}, #{$4}"), [ @current_entry ])
    @days << @current_day

    # skip the next two lines...
    3.times { line = read_and_process_line(line) }
   
    @current_entry.process_time_line line

  elsif line =~ /^#{ TIME_SEPARATOR }$/ 

    # skip the next line...
    2.times { line = read_and_process_line(line) }
    @current_entry = Entry.new(nil, nil, [])
    @current_day.entries << @current_entry
    @current_entry.process_time_line line

  elsif @current_entry
    @current_entry.lines << line
  end
end

@days.each do |day|
  day.entries.each do |entry|

    print "Outputting #{day.date.to_s} #{entry.time}\n"
    # Much more reliable. Open pipes to external process
    stdin, stdout, stderr = Open3.popen3("dayone", "-d=\"#{day.date.to_s} #{entry.time}\"", "new")
    stdin.puts(entry.lines.join)
    stdin.close
    stdout.close
    stderr.close
  end
end
