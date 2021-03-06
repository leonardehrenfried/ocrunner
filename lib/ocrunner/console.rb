# color helpers originally courtesy of RSpec http://github.com/dchelimsky/rspec

module OCRunner
  module Console
    
    attr :output
    
    def colorize(text, color_code)
      "#{color_code}#{text.to_s}\033[0m"
    end

    def red(text); colorize(text, "\033[31m"); end
    def green(text); colorize(text, "\033[32m"); end
    def blue(text); colorize(text, "\033[34m"); end
    
    def indent(*args)
      if args.first.is_a? Numeric
        indents = args.first
        text = args.last
      else
        indents = 1
        text = args.first
      end
      "  " * indents + text.to_s
    end
    
    def execute(cmd, &block)
      IO.popen("#{cmd} 2>&1") do |f| 
        while line = f.gets do 
          yield line
        end
      end
    end
    
    def present(&block)
      puts
      yield
      puts
    end
   
    def clean_path(path)
      return 'unknown' if path.nil?
      @current_directory = Dir.pwd
      path.gsub(@current_directory + '/', '')
    end
    
    def out(line = '')
      @output ||= []
      @output << line.rstrip
    end
    
    def growl(message)
      if @options[:growl]
        execute "growlnotify -i \"xcodeproj\" -m \"#{message}\"" do |error|
          if error =~ /command not found/
            out red('You must have growl and growl notify installed to enable growl support. See http://growl.info.')
          end
        end
      end
    end
    
  end
end