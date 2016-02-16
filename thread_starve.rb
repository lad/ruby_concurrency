#!/usr/bin/env ruby

require 'logger'
require 'timeout'

class Worker
  def initialize(logger)
    @logger = logger
  end

  # This is run in several separate threads
  def run
    loop do
      count = 1
      begin
        Timeout.timeout(0.1) do
          loop do
            @logger.error("#{Thread.current}: In loop #{count}")
            count += 1
          end
        end
      rescue Exception => ex
        @logger.error("#{Thread.current}: In Exception #{count}")
      end
    end
  end
end

class ThreadPool
  def initialize(num_threads, logger)
    @num_threads = num_threads.to_i
    @logger = logger
  end

  def run
    Thread.new { loop { sleep 1 } }
    loop do
      @logger.error('----------')
      @logger.error("Outer loop")
      @logger.error('----------')

      # Create threads, one worker object per thread
      threads = []
      @num_threads.times do |i|
        worker = Worker.new(@logger)
        t = Thread.new { worker.run }
        t[:name] = "Name: #{i}"
        threads << t
      end

      # Join each thread
      threads.each_with_index do |thr, i|
        @logger.error('==========')
        @logger.error("Thread Count: #{Thread.list.count}")
        @logger.error("Join loop: #{i}: #{thr[:name]} #{thr.status}")

        thr.join if thr.alive?
      end

      # Loop is blocked by joins above until all worker threads have exited
      # Then we go around the loop and do it all again...
    end
  end

  def dump_threads
    write "-------\nTHREAD DUMP START\n-------"
    write "Count: #{Thread.list.size}"
    Thread.list.each do |thd|
      write '-----'
      write "#{thd.inspect} #{thd[:name]}"
      write "#{thd.backtrace.join("\n")}\n"
    end
    write "--------------\nTHREAD DUMP END\n--------------"
  end

  def write(msg)
    STDOUT.write("#{msg}\n")
  end
end

def main
  num_threads = ARGV[0] || 10
  logger = Logger.new(STDOUT)
  logger.error("thread-deadlock: #{RUBY_VERSION}, #{num_threads} threads")

  tl = ThreadPool.new(num_threads, logger)
  # Dump thread stacktraces on SIGUSR2
  Signal.trap(:USR2) { Thread.start { tl.dump_threads } }

  # this will block forever
  tl.run
end

main if __FILE__ == $0
