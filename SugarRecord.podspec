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

  rx_dependencies = lambda do |spec|
    spec.dependency 'RxSwift', '~> 2.0.0'
    spec.dependency 'RxCocoa', '~> 2.0.0'
    spec.dependency 'RxBlocking', '~> 2.0.0'
  end

  rac_dependencies = lambda do |spec|
    spec.dependency "ReactiveCocoa", "4.0.0-RC.1"
  end
  
  s.subspec "CoreData" do |sp|
    sp.source_files = ['SugarRecord/Source/CoreData/**/*.{swift}']
    sp.exclude_files = ['SugarRecord/Source/CoreData/Reactive/**/*.{swift}']
    sp.dependency 'SugarRecord/Foundation'
    sp.frameworks = ['CoreData']

    sp.subspec "Rx" do |spp|
      spp.source_files = ['SugarRecord/Source/Reactive/*.{swift}', 'SugarRecord/Source/CoreData/Reactive/**/*.{swift}']
      spp.exclude_files = ['SugarRecord/Source/Reactive/ReactiveCocoa/**/*.{swift}']
      rx_dependencies.call(spp)
    end

    sp.subspec "ReactiveCocoa" do |spp|
      spp.source_files = ['SugarRecord/Source/Reactive/*.{swift}', 'SugarRecord/Source/CoreData/Reactive/**/*.{swift}']
      spp.exclude_files = ['SugarRecord/Source/Reactive/Rx/**/*.{swift}']
      rac_dependencies.call(spp)
    end
  end

  s.subspec "Realm" do |sp|
    sp.source_files = ['SugarRecord/Source/Realm/**/*.{swift}']
    sp.exclude_files = ['SugarRecord/Source/Realm/Reactive/**/*.{swift}']
    sp.dependency 'SugarRecord/Foundation'
    sp.dependency "RealmSwift", "~> 0.97"

    sp.subspec "Rx" do |spp|
      spp.source_files = ['SugarRecord/Source/Reactive/*.{swift}', 'SugarRecord/Source/Realm/Reactive/**/*.{swift}']
      spp.exclude_files = ['SugarRecord/Source/Reactive/ReactiveCocoa/**/*.{swift}']
      rx_dependencies.call(spp)
    end

    sp.subspec "ReactiveCocoa" do |sp|
      spp.source_files = ['SugarRecord/Source/Reactive/*.{swift}', 'SugarRecord/Source/Realm/Reactive/**/*.{swift}']
      spp.exclude_files = ['SugarRecord/Source/Reactive/Rx/**/*.{swift}']
      rac_dependencies.call(spp)
    end
  end
end
