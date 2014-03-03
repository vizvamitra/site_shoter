class String
  def colorize(code)
    "\x1B[#{code}m" + self + "\x1B[0m"
  end
  
  def red; colorize(31); end
  def green; colorize(32); end
  def blue; colorize(34); end
end

##### SITE SHOTER #####
class SiteShoter
	DEFAULT_FORMAT = 'png'
	DEFAULT_WIDTH = 1200
	DEFAULT_QUALITY = 94
	TMP_FILE = "/tmp/#{Time.now.to_i}.site_shoter"

	def initialize(link, options={})
		@source = link
		@format = options[:format] || DEFAULT_FORMAT
		@height = options[:height] || nil
		@width = options[:width] || DEFAULT_WIDTH
		@quality = options[:quality] || DEFAULT_QUALITY
		@no_images = options[:no_images] || false
		@disable_javascript = options[:disable_javascript] || false
		@encoding = options[:encoding] || nil
	end

	# saves screenshot to 'file' and returns the corresponding File object
	def to_file out_file
		@out_file = out_file
		create_files()
		set_sigint_trap()

		params = get_params_string()
		# here download happens
		execute_wkhtmltoimage(params, TMP_FILE)

		copy_tmp_to_output()

		# cheking for all to be ok
		done_check()
	end

private

	def create_files
		begin
			temp = File.new(TMP_FILE, 'w')
			output = File.new(@out_file, 'w')
		rescue
			raise IOError, "Unable to create temp file" if temp.nil?
			raise IOError, "Unable to create output file" if output.nil?
		end
	end

	def get_params_string
		params = "--format #{@format} --width #{@width} --quality #{@quality}"
		params << " --height #{@height}" if @height
		params << " --no-images" if @no_images
		params << " --disable-javascript" if @disable_javascript
		params << " --encoding #{@encoding}" if @encoding
		params
	end
	
	def set_sigint_trap
		trap("SIGINT") do
			begin
				File.delete(@out_file)
				File.delete(TMP_FILE)
			rescue
			end
			exit
		end
	end

	def copy_tmp_to_output
		begin
			str = IO.read(TMP_FILE)
			File.open(@out_file, 'w'){ |f| f.syswrite(str) }
		rescue
			raise "Unrecognized IO error. Sorry for that"
		ensure
			File.delete(TMP_FILE)
		end
	end

	def done_check
		if IO.read(@out_file).length == 0
			File.delete(@out_file)
			raise "Unable to take a screenshot from '#{@source}'.\nCheck your link.\n\
				\rIf it is correct, try using -ni (no images) or -nj (no javascript) options.\n\
				\rAlso not specifying width and/or height could help"
		else
			begin
				return File.new(@out_file, 'r')
			rescue
				raise IOError, "Unrecognized IO error. Sorry for that"
			end
		end
	end

	def execute_wkhtmltoimage(params, filename)
		Thread.abort_on_exception = true
		work_thread = Thread.new do
			%x{wkhtmltoimage #{params} #{@source} #{filename} 2> /dev/null}
		end
		control_thread = Thread.new do
			sleep(15)
			if work_thread.alive?
				work_thread.exit
				raise ThreadError, "Couldn't connect to '#{@source}'. Check your link or try later" 
			end
		end
		work_thread.join
	end
end