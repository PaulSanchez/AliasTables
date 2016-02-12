#!/usr/bin/env ruby -w

require_relative '../lib/aliastable.rb'

nvars = 1_000_000
begin
  at = AliasTable.new(%w(yes no), [0.3, 0.3, 0.4])
  nvars.times { print at.generate, "\n" }
rescue RuntimeError => e
  p e
  puts
end
Dir['test/infile.*'].each do |f_name|
  x = []
  probs = []
  f = File.open(f_name, 'r')
  counts = {}
  expected_counts = {}
  while line = f.gets
    inputs = line.strip.split(/[\s,;:]+/)
    x << inputs[0]
    counts[inputs[0]] = 0
    probs << inputs[1].to_r
    n_hat = probs[-1] * nvars
    half_width = 2.5 * Math.sqrt(n_hat * (1.0 - probs[-1])) if n_hat > 0
    expected_counts[inputs[0]] = [n_hat, half_width]
  end
  f.close
  begin
    at = AliasTable.new(x, probs)
    nvars.times do
      element = at.generate
      unless x.include?(element)
        raise "AliasTable generated an element not included in original sample: #{element.inspect}"
      end
      counts[element] += 1
    end
    puts 'All values should be in range almost always:'
    counts.each_key do |k|
      printf "%s: Allowable Range = %d, Expected - Observed = %d\n",
             k, expected_counts[k][1], expected_counts[k][0] - counts[k]
    end
    puts
  rescue RuntimeError => e
    p e
    puts
  end
end
