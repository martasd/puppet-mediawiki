module Puppet::Parser::Functions
newfunction(:gen_target_path, :type => :rvalue) do |arguments|
    source_dir = arguments[0]
    filepath = arguments[1]
    index = filepath.rindex('/')+1
    
    filename = filepath[index..-1]
    
    fullpath = source_dir+'/'+filename
    return fullpath
  end
end


    

