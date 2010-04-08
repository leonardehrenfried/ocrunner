module OCRunner
  class TestRunner
    include Console
    
    class BuildFailure < StandardError; end
  
    attr_reader :suites, :current_directory, :options, :log, :command
    
    def initialize(options)
      @suites = []
      @log = ''
      @current_directory = Dir.pwd
      @options = options
      @passed = true
      
      build_command
      run_tests
      display_summary
      display_log
    end
  
    def build_command
      @command = "xcodebuild -target #{@options[:target]} -configuration #{@options[:config]} " +
                 "-sdk #{@options[:sdk]} #{@options[:parallel] ? '-parallelizeTargets' : ''} build"
     if @options[:debug_command]
       puts @command
       exit
     end
    end
  
    def run_tests
      IO.popen("#{@command} 2>&1") do |f| 
        while line = f.gets do 
          @log << line
          process_console_output(line)
          $stdout.flush
        end
      end
    end
  
    def display_summary
      @suites.each do |suite|
        suite.cases.reject {|kase| kase.passed}.each do |kase|
          puts
          puts '  ' + red("[#{suite.name} #{kase.name}] FAIL")
          kase.errors.each do |error|
            puts '    ' + red(error.message) + " line #{error.line} of #{clean_path(error.path)}"
          end
        end
        puts
      end
      
      @suites.each do |suite|
        failed = suite.cases.reject {|c| c.passed}
        puts "Suite '#{suite.name}': #{suite.cases.size - failed.size} passes and #{failed.size} failures in #{suite.time} seconds."
      end
      
      puts
      
      if @passed
        build_succeeded
      else
        build_failed
      end
    end
    
    def build_error(message)
      puts red(message)
      @passed = false
    end

    def build_failed
      growl('BUILD FAILED!')
      puts red('*** BUILD FAILED ***')
    end
    
    def build_succeeded
      growl('Build succeeded.')
      puts green('*** BUILD SUCCEEDED ***')
    end
  
    def display_log
      puts @log if @options[:verbose]
    end

    def process_console_output(line)

      # test case started
      if line =~ /Test Case '-\[.+ (.+)\]' started/
        @current_case = TestCase.new($1)
        @current_suite.cases << @current_case
      end
    
      # test case passed
      if line =~ /Test Case .+ passed/
        @current_case.passed = true
        @current_suite.cases << @current_case
        @current_case = nil
        print(green('.'))
      end
      
      # test failure
      if line =~ /(.+\.m):(\d+): error: -\[(.+) (.+)\] :(?: (.+):?)? /
        @current_case.passed = false
        @current_case.errors << TestError.new($1, $2, $5)
        print red('.')
      end

      # start test suite
      if line =~ /Test Suite '([^\/]+)' started/
        @current_suite = TestSuite.new($1)
        print "#{$1} "
      end

      # finish test suite
      if @current_suite && line =~ /^Executed/ && line =~ /\(([\d\.]+)\) seconds/
        @current_suite.time = $1
        @suites << @current_suite
        @current_suite = nil
        print "\n" # clear console line
      end

      # test executable not found
      if line =~ /The executable for the test bundle at (.+\.octest) could not be found/
        build_error("Test executable #{clean_path($1)} could not be found")
      end
      
      # compilation reference error
      if line =~ /"(.+)", referenced from:/
        puts red($&)
      end
      if line =~ /-\[\w+ \w+\] in .+\.o/
        puts red($&)
      end
      
      # no Xcode project found
      if line =~ /does not contain an Xcode project/
        build_error('No Xcode project was found.')
      end
      
    end
    
    def clean_path(path)
      path.gsub(@current_directory + '/', '')
    end
  
    def growl(message)
      if @options[:growl]
        `growlnotify -i "xcodeproj" -m "#{message}" `
      end
    end
  
  end
end