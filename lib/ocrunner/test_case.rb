module OCRunner
  class TestCase
    
    # Container for test case info

    attr :name
    attr_accessor :passed
    attr_accessor :errors
        
    def initialize(name)
      @name = name
      @errors = []
      @passed = true
    end
    
    def fail!
      @passed = false
    end
    
    def passed?
      @passed
    end
  end
end