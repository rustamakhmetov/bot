require './service/cabinet'
require 'optparse'

class Parser
  def self.parse(custom_options=ARGV)
    options = {timeout: 30}
    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: bot.rb email password app_url [options]"

      opts.on("-t", "--timeout [INTEGER]", Integer, "Timeout sec. default: 30") do |v|
        options[:timeout] = v
      end

      opts.on_tail("-h", "--help", "Prints this help") do
        puts opts
      end
    end

    opt_parser.parse!(custom_options)
    return options
  end
end

options = Parser.parse
if ARGV.count<3
  Parser.parse %w[--help]
  exit
end

begin
  cab = Cabinet.new(options)
  cab.login(ARGV[0], ARGV[1])
  app_id=cab.add_app(ARGV[2])
  cab.add_all_placements(app_id)
  puts cab[app_id].to_json
  puts "done!"
rescue Errors::UnprocessableEntity => e
  puts "Error: #{e.message}"
rescue Watir::Wait::TimeoutError
  puts "Error: Increase timeout, current value = #{Watir.default_timeout} sec."
end