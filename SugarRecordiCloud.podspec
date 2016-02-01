Pod::Spec.new do |s|
  s.name             = "SugarRecordiCloud"
  s.version          = "2.2.0"
  s.summary          = "SugarRecord extension adding iCloud support"
  s.homepage         = "https://github.com/pepibumur/SugarRecord"
  s.license          = 'MIT'
  s.author           = { "Pedro" => "pedro@gitdo.io" }
  s.source           = { :git => "https://github.com/pepibumur/SugarRecord.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pepibumur'
  s.requires_arc = true

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"

  s.source_files = [ 'SugarRecord/Source/CoreData/Entities/iCloudConfig.swift', 'SugarRecord/Source/CoreData/Storages/CoreDataiCloudStorage.swift']

  s.dependency "SugarRecord"

  s.subspec "RX" do |spec|
    spec.dependency "SugarRecord/CoreData+RX"
  end

  s.subspec "RAC" do |spec|
    spec.dependency "SugarRecord/CoreData+RAC"
  end

end
