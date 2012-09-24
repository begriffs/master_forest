require_relative '../lib/master_forest'
require 'benchmark'
include MasterForest

def show_performance &blk
  puts Benchmark.measure &blk
end

[Term].each do |impl|
  puts "*"*80
  puts "Benchmarking #{impl} implementation"
  [
    "`````s`ss`ss`ssss"
  ].each do |term|
    puts "Reduce #{term}"
    2.times do |i|
      puts "#{i+1})"
      show_performance do
        t = impl.new term
        t.fully_reduce
      end
    end
    puts "-"*45
  end
end
