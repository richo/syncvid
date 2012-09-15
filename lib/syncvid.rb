module SyncVid
end

Dir["lib/syncvid/**"].each do |file|
  require File.expand_path("../../#{file}", __FILE__)
end
