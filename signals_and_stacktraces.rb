#!/usr/bin/env ruby

# Example of how to use IO.pipe to safely inidcate the arrival of a signal
# ...and to use that signal to dump out the stacktraces of all running threads

def setup_signal_handler
  # Setup the signal handler
  reader, writer = IO.pipe
  handle_signals_thread(reader)

  Signal.trap('USR2') do
    writer.puts('USR2')
  end
end

def handle_signals_thread(signal_pipe)
  thd = Thread.new do
    loop do
      sig = signal_pipe.gets.chomp  # this blocks
      case sig
      when 'USR2'
        thread_dump
      when 'INT'
        # <-- server shutdown code goes here -->
        # break and exit the signal handling thread
        break
      end
    end
  end
  thd[:name] = 'Signal handler'
end

def thread_dump
  thread_count = Thread.list.size
  write("Thread Count (#{thread_count})")
  Thread.list.each do |thd|
    write("-----\n#{thd.inspect} #{thd[:name] if thd[:name]}")
    write(thd.backtrace.join("\n"))
  end
  write("End of threads (#{thread_count})")
end

def self.write(msg)
  STDOUT.puts(msg)
  STDOUT.flush
end

def dummy_thread_worker
  puts "#{Thread.current}: dummy-thread-worker-start"
  loop do
    sleep 10
  end
end


def main
  puts "PID: #{Process.pid}"
  setup_signal_handler
  threads = []
  3.times do
    threads << Thread.new { dummy_thread_worker }
  end

  threads.each { |t| t.join }
end

main if __FILE__ == $0
