Pod::Spec.new do |s|
  s.name             = "SugarRecord"
  s.version          = "2.1.8"
  s.summary          = "CoreData wrapper written on Swift"
  s.homepage         = "https://github.com/pepibumur/SugarRecord"
  s.license          = 'MIT'
  s.author           = { "Pedro" => "pedro@gitdo.io" }
  s.source           = { :git => "https://github.com/pepibumur/SugarRecord.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pepibumur'
  s.requires_arc = true

  spec.default_subspecs = 'Realm', 'CoreData'

  s.tvos.deployment_target = '9.0'
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
    spec.dependency "ReactiveCocoa", "4.0.0-RC.1"
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

  s.subspec "CoreData" do  |spec|
    spec.source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}']
    spec.exclude_files = ['SugarRecord/Source/CoreData/Reactive/**/*.{swift}']
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
  end

  s.subspec "CoreData+RX" do |spec|
    spec.source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}', 'SugarRecord/Source/Reactive/**/*.{swift}']
    spec.exclude_files = ['SugarRecord/Source/Reactive/ReactiveCocoa/**/*.{swift}']
    rx_dependencies.call(spec)
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
  end

  s.subspec "CoreData+RAC" do  |spec|
    spec.source_files = ['SugarRecord/Source/Foundation/**/*.{swift}', 'SugarRecord/Source/CoreData/**/*.{swift}', 'SugarRecord/Source/Reactive/**/*.{swift}']
    spec.exclude_files = ['SugarRecord/Source/Reactive/Rx/**/*.{swift}']
    rac_dependencies.call(spec)
    coredata_dependencies.call(spec)
    foundation_dependencies.call(spec)
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
