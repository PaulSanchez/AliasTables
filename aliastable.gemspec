# -*- ruby -*-
_VERSION = "3.1.0"

Gem::Specification.new do |s|
  s.name = "aliastable"
  s.version = _VERSION
  s.date = "2018-01-16"
  s.summary = "Efficiently generate random outcomes from an arbitrary categorical distribution."
  s.email = "pjs@alum.mit.edu"
  s.description = "If a categorical distribution has k distinct values, traditional approaches will require O(k) work to pick an outcome with the correct probabilities.  This algorithm uses conditional probability to construct a table which will yield outcomes with the correct probabilities. Table generation requires O(k) time, but subsequent generation is done in O(1) time."
  s.author = "Paul J Sanchez"
  s.files = %w[
    aliastable.gemspec
    lib/aliastable.rb
    Rakefile
    test/infile.bad.1
    test/infile.bad.2
    test/infile.bad.3
    test/infile.good.1
    test/infile.good.2
    test/infile.good.3
    test/infile.good.4
    test/test_alias.rb
  ]
  s.required_ruby_version = '>= 2.0.0'
  s.license = 'LGPL'
end
