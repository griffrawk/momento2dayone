Entry = Struct.new(:time, :tags, :lines)

class Entry
  def process_time_line(line)
    if line =~ /^(\d{1,2}\:\d\d) (.*)\n$/

    # lines dont have AM PM on so this regexp wont work
    # if line =~ /^(\d{1,2}\:\d\d) (AM|PM) (.*)\r\n$/

      self.time = "#{$1}"

      # ignore the non-existent AM PM bit
      # self.time = "#{$1}#{$2}"

      lines << "#{$2}\r\n"

      # not $3 anymore
      # lines << $3
    else
      # assume line doesnt have a time and default one
      self.time = "12:00"
      lines <<  "#{line}"
    end
  end
end
