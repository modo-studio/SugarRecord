Pod::Spec.new do |s|
  s.name             = "SugarRecord"
  s.version          = "2.0.0"
  s.summary          = "CoreData wrapper written on Swift"
  s.homepage         = "https://github.com/SwiftReactive/SugarRecord"
  s.license          = 'MIT'
  s.author           = { "Pedro" => "pedro@gitdo.io" }
  s.source           = { :git => "https://github.com/SwiftReactive/SugarRecord.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pepibumur'
  s.requires_arc = true

  s.tvos.deployment_target = '9.0'
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = '9.0'

  s.subspec "Foundation" do |sp|
    sp.source_files = ['SugarRecord/Source/Foundation/**/*']
    sp.dependency "ReactiveCocoa", "4.0.4-alpha-4"
  end

  s.subspec "CoreData" do |sp|
    sp.source_files = ['SugarRecord/Source/CoreData/**/*']
    sp.dependency 'SugarRecord/Foundation'
    sp.frameworks = ['CoreData']
  end

  # No tvOS support yet
  # s.subspec "Realm" do |sp|
  #   sp.platforms = [:ios, :tvos]
  #   sp.source_files = ['SugarRecord/Source/Realm/**/*']
  #   sp.dependency 'SugarRecord/Foundation'
  #   sp.dependency 'RealmSwift'
  # end

end
