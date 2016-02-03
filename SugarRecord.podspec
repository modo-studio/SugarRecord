Pod::Spec.new do |s|
  s.name             = "SugarRecord"
  s.version          = "2.2.1"
  s.summary          = "CoreData wrapper written on Swift"
  s.homepage         = "https://github.com/pepibumur/SugarRecord"
  s.license          = 'MIT'
  s.author           = { "Pedro" => "pedro@gitdo.io" }
  s.source           = { :git => "https://github.com/pepibumur/SugarRecord.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pepibumur'
  s.requires_arc = true

  s.default_subspecs = 'Realm', 'CoreData'

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = '9.0'

  rx_dependencies = lambda do |spec|
    spec.dependency 'RxSwift', '~> 2.0.0'
    spec.dependency 'RxCocoa', '~> 2.0.0'
    spec.dependency 'RxBlocking', '~> 2.0.0'
  end

  rac_dependencies = lambda do |spec|
    spec.dependency "ReactiveCocoa", "4.0.0-RC.2"
  end

  realm_dependencies = lambda do |spec|
    spec.dependency "RealmSwift", "~> 0.97"
  end

  coredata_dependencies = lambda do |spec|
    spec.frameworks = ['CoreData']
  end

  foundation_dependencies = lambda do |spec|
    spec.dependency "Result", "~> 1.0"
  end

  all_platforms = lambda do |spec|
    # spec.ios.deployment_target = "8.0"
    # spec.osx.deployment_target = "10.10"
    # spec.watchos.deployment_target = "2.0"
    # spec.tvos.deployment_target = '9.0'
  end

  all_icloud_supported_platforms = lambda do |spec|
    spec.ios.deployment_target = "8.0"
    spec.osx.deployment_target = "10.10"
    spec.watchos.deployment_target = nil
    spec.tvos.deployment_target = nil
  end

  excluded_icloud_files = ['SugarRecord/Source/CoreData/Entities/iCloudConfig.swift', 'SugarRecord/Source/CoreData/Storages/CoreDataiCloudStorage.swift']

  s.subspec "CoreData" do  |spec|
    source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}']
    excluded_files = ['SugarRecord/Source/CoreData/Reactive/**/*.{swift}']
    spec.source_files = source_files
    spec.exclude_files = excluded_files + excluded_icloud_files
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
    all_platforms.call(spec)
  end

  s.subspec "CoreData+iCloud" do  |spec|
    source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}']
    excluded_files = ['SugarRecord/Source/CoreData/Reactive/**/*.{swift}']
    spec.source_files = source_files
    spec.exclude_files = excluded_files
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
    all_icloud_supported_platforms.call(spec)
  end

  s.subspec "CoreData+RX" do |spec|
    source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}', 'SugarRecord/Source/Reactive/**/*.{swift}']
    excluded_files = ['SugarRecord/Source/Reactive/ReactiveCocoa/**/*.{swift}']
    spec.source_files = source_files
    spec.exclude_files = excluded_files + excluded_icloud_files
    rx_dependencies.call(spec)
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
    all_platforms.call(spec)
  end

  s.subspec "CoreData+RX+iCloud" do |spec|
    source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}', 'SugarRecord/Source/Reactive/**/*.{swift}']
    excluded_files = ['SugarRecord/Source/Reactive/ReactiveCocoa/**/*.{swift}']
    spec.source_files = source_files
    spec.exclude_files = excluded_files
    rx_dependencies.call(spec)
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
    all_icloud_supported_platforms.call(spec)
  end


  s.subspec "CoreData+RAC" do  |spec|
    source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}', 'SugarRecord/Source/Reactive/**/*.{swift}']
    excluded_files = ['SugarRecord/Source/Reactive/Rx/**/*.{swift}']
    spec.source_files = source_files
    spec.exclude_files = excluded_files + excluded_icloud_files
    rac_dependencies.call(spec)
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
    all_platforms.call(spec)
  end

  s.subspec "CoreData+RAC+iCloud" do  |spec|
    source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}', 'SugarRecord/Source/Reactive/**/*.{swift}']
    excluded_files = ['SugarRecord/Source/Reactive/Rx/**/*.{swift}']
    spec.source_files = source_files
    spec.exclude_files = excluded_files
    rac_dependencies.call(spec)
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
    all_icloud_supported_platforms.call(spec)
  end

  s.subspec "Realm" do  |spec|
    spec.source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/Realm/**/*.{swift}']
    spec.exclude_files = ['SugarRecord/Source/Realm/Reactive/**/*.{swift}']
    realm_dependencies.call(spec)
    foundation_dependencies.call(spec)
  end

  s.subspec "Realm+RX" do |spec|
    spec.source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/Realm/**/*.{swift}', 'SugarRecord/Source/Reactive/**/*.{swift}']
    spec.exclude_files = ['SugarRecord/Source/Reactive/ReactiveCocoa/**/*.{swift}']
    rx_dependencies.call(spec)
    realm_dependencies.call(spec)
    foundation_dependencies.call(spec)
  end

  s.subspec "Realm+RAC" do  |spec|
    spec.source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/Realm/**/*.{swift}', 'SugarRecord/Source/Reactive/**/*.{swift}']
    spec.exclude_files = ['SugarRecord/Source/Reactive/Rx/**/*.{swift}']
    rac_dependencies.call(spec)
    realm_dependencies.call(spec)
    foundation_dependencies.call(spec)
  end

end
