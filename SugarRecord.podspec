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

  s.tvos.deployment_target = '9.0'
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = '9.0'

  s.subspec "Foundation" do |sp|
    sp.source_files = ['SugarRecord/Source/Foundation/**/*.{swift}']
    sp.exclude_files = ['SugarRecord/Source/Reactive/**/*.{swift}']
    sp.dependency "Result", "~> 1.0"
  end
  
  s.subspec "Reactive" do |sp|
    sp.source_files = ['SugarRecord/Source/Reactive/*.{swift}', 'SugarRecord/Source/CoreData/Reactive/**/*.{swift}', 'SugarRecord/Source/Realm/Reactive/**/*.{swift}']
    sp.dependency 'SugarRecord/Foundation'
  end
  
  s.subspec "ReactiveCocoa" do |sp|
    sp.source_files = ['SugarRecord/Source/Reactive/ReactiveCocoa/**/*.{swift}']
    sp.dependency 'SugarRecord/Reactive'
    sp.dependency "ReactiveCocoa", "4.0.0-RC.1"
  end
  
  s.subspec "Rx" do |sp|
    sp.source_files = ['SugarRecord/Source/Reactive/Rx/**/*.{swift}']
    sp.dependency 'SugarRecord/Reactive'
    sp.dependency 'RxSwift', '~> 2.0.0'
    sp.dependency 'RxCocoa', '~> 2.0.0'
    sp.dependency 'RxBlocking', '~> 2.0.0'
  end

  s.subspec "CoreData" do |sp|
    sp.source_files = ['SugarRecord/Source/CoreData/**/*.{swift}']
    sp.exclude_files = ['SugarRecord/Source/CoreData/Reactive/**/*.{swift}']
    sp.dependency 'SugarRecord/Foundation'
    sp.frameworks = ['CoreData']
  end

  s.subspec "Realm" do |sp|
    sp.source_files = ['SugarRecord/Source/Realm/**/*.{swift}']
    sp.exclude_files = ['SugarRecord/Source/Realm/Reactive/**/*.{swift}']
    sp.dependency 'SugarRecord/Foundation'
    sp.dependency "RealmSwift", "~> 0.97"
  end
end
