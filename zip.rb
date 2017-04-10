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

  paths.map{|e|File.expand_path e}.each do | path |
    basename = File.basename path
    dirname = File.dirname path
    internal_path = path.sub %r[^#{__dir__}/], ''

    archive = File.join(dirname, basename) + '.zip'
    FileUtils.rm archive, force: true

    Zip::File.open(archive, Zip::File::CREATE) do | zipfile |
      if File.directory? path
        Dir["#{internal_path}/**/**"].map{|e|e.sub %r[^#{internal_path}/],''}.reject{|f|f==archive}.each do | item |
          zipfile.add(item, File.join(internal_path, item))
        end
      elsif File.file? path
        zipfile.add(internal_path, path)
      end
    end
  end
end
