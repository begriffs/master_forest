require_relative '../lib/master_forest'
require 'benchmark'
include MasterForest

def show_performance &blk
  print Benchmark.measure &blk
end

[Term, MemcacheTerm].each do |impl|
  puts "*"*80
  puts "Benchmarking #{impl} implementation"
  [
    "```````sss`ssisss", "`````s``ssii`ssss", "`````sii``ss`ssss",
    "`````sii```ssssss", "```````s`ssssisss", "`````s`ss`ss`ssss",
    "``````ssi``ssssss", "``````ssi`ss`ssss", "`````s`s`ssi`ssss"
  ].each do |term|
    puts "Reduce #{term}"
    2.times do |i|
      print "#{i+1})"
      show_performance do
        t = impl.new term
        t.fully_reduce
      end
    end
    puts
  end
end
