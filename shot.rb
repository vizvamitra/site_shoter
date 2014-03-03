#!/usr/bin/env ruby

require './lib/site_shoter'

##### APP #####
class App

  def initialize
    begin
      options = parse_args
    rescue => e
      error(e.message)
      usage()
      exit()
    end
    link = options.delete(:link)
    output = options.delete(:output)

    img = SiteShoter.new(link, options)

    begin
      img.to_file(output)
    rescue => e
      error(e.message)
      exit()
    end
  end

  def parse_args
    regexes = { link: / (https?:\/\/[\w\d\.\-_]+\.[\w]{2,6}(:\d{2,5})?\/?([-\.\/[:word:]?&=]+)*)/,
                width:  / -w (\d+)/, height:  / -h (\d+)/,
                format: / -f (\w+)/, quality: / -q (\d+)/,
                no_images: / (-ni)/, disable_javascript: / (-nj)/,
                encoding: / -e ([\w\d-]+)/,
                output: / (\/?([-\.$#@!*()? =\/[:word:]])+[^\/\\ ])$/ }
    options = {}

    args = ' ' + ARGV.join(' ')

    regexes.each do |key, regex|
      match = args.match(regex)
      if match
        options[key] = match[1]
        args.sub!(regex, '')
      else
        raise(ArgumentError, "No link given") if key == :link
        raise(ArgumentError, "Output file should be specified") if key == :output
      end
    end
    
    if q = options[:quality]
      msg = "Quality value should be between 0 and 100"
      raise(RangeError, msg) unless (0..100).include?(q.to_i)
    end
    raise(ArgumentError, "Unrecognized part of parameters string: #{args}") unless args.length.zero?

    return options
  end

  def usage
    puts "#{"Description".green}:"
    puts "  Site Shoter is a simple Ruby wrapper to wkhtmltoimage tool\n\n"
    puts "#{"USAGE".green}:"
    puts "  shot.rb [OPTIONS] LINK OUTPUT_FILE\n\n"
    puts "  LINK\t\t\tSite URI. Should begin with http(s)://\n\n"
    puts "  OUTPUT_FILE\t\tFile where result will be stored\n\n"
    puts "  OPTIONS:\n\n"
    puts "    -w <int>\t\tSet screen width (default 1200)\n"
    puts "    -h <int>\t\tSet screen height (default is calculated\n\t\t\tfrom page content)\n"
    puts "    -q <int>\t\tOutput image quality (between 0 and 100, default 94)\n"
    puts "    -f <format>\t\tOutput file format (default png)\n"
    puts "    -e <encoding>\t\tSet page encoding\n"
    puts "    -ni\t\t\tImages won't be downloaded\n"
    puts "    -nj\t\t\tDisable javascript\n"

    puts "\nMade for you by Vizvamitra (#{"vizvamitra@gmail.com".blue}, Russia)"
  end

  def error(message)
    puts "ERROR".red + ": " + message
  end
end

app = App.new