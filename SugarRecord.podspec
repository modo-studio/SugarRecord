Pod::Spec.new do |s|
  s.name             = "SugarRecord"
  s.version          = "3.1.2"
  s.summary          = "CoreData wrapper written on Swift"
  s.homepage         = "https://github.com/carambalabs/SugarRecord"
  s.license          = 'MIT'
  s.author           = { "Pedro" => "pepibumur@gmail.com" }
  s.source           = { :git => "https://github.com/carambalabs/SugarRecord.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/carambalabs'
  s.requires_arc = true

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"

  coredata_dependencies = lambda do |spec|
    spec.frameworks = ['CoreData']
  end

  foundation_dependencies = lambda do |spec|
    spec.dependency "Result", "~> 3.0"
  end

  all_platforms = lambda do |spec|
    spec.ios.deployment_target = "8.0"
    spec.osx.deployment_target = "10.10"
    spec.watchos.deployment_target = "2.0"
    spec.tvos.deployment_target = '9.0'
  end

  excluded_icloud_files = ['SugarRecord/Source/CoreData/Entities/iCloudConfig.swift', 'SugarRecord/Source/CoreData/Storages/CoreDataiCloudStorage.swift']

  s.subspec "CoreData" do  |spec|
    source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}']
    spec.source_files = source_files
    spec.exclude_files =  excluded_icloud_files
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
    all_platforms.call(spec)
  end

  s.subspec "CoreData+iCloud" do  |spec|
    source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}']
    spec.source_files = source_files
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
  end

end
