module Puppet::Parser::Functions
  newfunction(:gen_uniq_path, :type => :rvalue) do |arguments|
    conf_dir = arguments[0]
    instance_dir = arguments[1]
    files = arguments[2]
    
    link_dir = conf_dir+'/'+instance_dir
    
    link_files = (files.collect{|file| link_dir+'/'+file})
    return link_files
  end
end
