module Input
  TIME_SEPARATOR = "---\r\n"
  
  def read_and_process_line(line)
    line = ARGF.readline
    # ignore as it screws up lines
    # Input.process_line(line)
  end
  
  def process_line(line)
    rv = ""

    # this returns undefined_conversion when seeing ñ and chops line at that point:
    Encoding::Converter.new('utf-8', 'ascii').primitive_convert(line, rv)

    # this changes all double quotes to single. not what we want?
    rv.gsub(/"/, "'")
  end
end

