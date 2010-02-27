# http://linux.die.net/man/1/irb
require 'irb/completion'
# IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

require 'pp'

load File.dirname(__FILE__) + '/.railsrc' if $0 == 'irb' && ENV['RAILS_ENV']

def time(times = 1)
  ret = nil
  Benchmark.bm { |x| x.report { times.times { ret = yield } } }
  ret
end

def copy(data)
  File.popen('pbcopy', 'w') { |p| p << data.to_s }
  $?.success?
end

def copy_history
  history = Readline::HISTORY.entries
  index = history.rindex("exit") || history.rindex("quit") || -1
  content = history[(index+1)..-2].join("\n")
  puts content
  copy content
end

if defined? Benchmark
  class Benchmark::ReportProxy
    def initialize(bm, iterations)
      @bm = bm
      @iterations = iterations
      @queue = []
    end
    
    def method_missing(method, *args, &block)
      args.unshift(method.to_s + ':')
      @bm.report(*args) do
        @iterations.times { block.call }
      end
    end
  end

  def compare(times = 1, label_width = 12)
    Benchmark.bm(label_width) do |x|
      yield Benchmark::ReportProxy.new(x, times)
    end
  end
end