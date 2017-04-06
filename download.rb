#!/usr/bin/env ruby

require 'open-uri'

require 'ruby-progressbar'

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

  argv.each do | url |
    pbar = nil
    open(url,
    :content_length_proc => lambda {| total |
      if total && 0 < total
        pbar = ProgressBar.create total: total
      end
    },
    :progress_proc => lambda {|s|
      pbar.progress = s if pbar
    }) do | flow |
      if flow.meta["name"]
        name = flow.meta["name"]
      else
        name = File.basename url
      end
      open name, 'a' do | f |
        f.write flow.read
      end
    end
  end

end
