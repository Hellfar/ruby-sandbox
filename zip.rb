#!/usr/bin/env ruby

require 'zip'

if __FILE__ == $0

  require 'optparse'

  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options[:verbose] = v
    end
  end.parse!

  argv = ARGV.select{true}

  paths = argv

  paths.each do | path |
    if File.directory? path
      type = :d
    elsif File.file? path
      type = :f
    end

    case type
    when :d
      path = File.expand_path path
      archive = File.join(__dir__, File.basename(path)) + '.zip'
# p archive
    when :f
      basename = File.basename(path)
      archive = path + '.zip'
    end
    FileUtils.rm archive, force: true
# p archive
    Zip::File.open(archive, Zip::File::CREATE) do | zipfile |
      case type
      when :d
        Dir["#{path}/**/**"].reject{|f|f==archive}.each do | item |
          basename = File.basename(item)
# p basename
# p item
          zipfile.add(basename, item)
        end
      when :f
# p path
        zipfile.add(basename, path)
      end
    end
  end
end
