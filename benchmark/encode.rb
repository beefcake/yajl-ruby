# encoding: UTF-8
require 'rubygems'
require 'benchmark'
require 'yajl'
require 'json'
# Can't use ActiveSuport::JSON.encode with the JSON gem loaded
# require 'activesupport'

filename = ARGV[0] || 'benchmark/subjects/contacts.json'
json = File.new(filename, 'r')
hash = Yajl::Stream.parse(json)
json.close

times = ARGV[1] ? ARGV[1].to_i : 1
puts "Starting benchmark encoding #{filename} #{times} times\n\n"
Benchmark.bm { |x|
  x.report {
    puts "Yajl::Stream.encode (C)"
    times.times {
      Yajl::Stream.encode(hash, StringIO.new)
    }
  }
  x.report {
    puts "JSON's #to_json"
    times.times {
      hash.to_json
    }
  }
  # Can't use ActiveSuport::JSON.encode with the JSON gem loaded
  #
  # x.report {
  #   puts "ActiveSupport::JSON.encode"
  #   times.times {
  #     ActiveSupport::JSON.encode(hash)
  #   }
  # }
}
# io = StringIO.new
# Yajl::Stream.encode(hash, io)
# io.rewind
# puts io.read
# puts ""
# puts hash.to_json
