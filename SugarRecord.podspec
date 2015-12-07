Pod::Spec.new do |s|
  s.name             = "SugarRecord"
  s.version          = "2.0.0"
  s.summary          = "CoreData wrapper written on Swift"
  s.homepage         = "https://github.com/gitdoapp/SugarRecord"
  s.license          = 'MIT'
  s.author           = { "Pedro" => "pedro@gitdo.io" }
  s.source           = { :git => "https://github.com/gitdoapp/SugarRecord.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pepibumur'
  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = "10.10"

  s.dependency 'Result', '~> 1.0'

  s.subspec "Foundation" do |sp|
    sp.source_files = ['SugarRecord/SugarRecord/Source/Foundation/**/*']
  end

  s.subspec "CoreData" do |sp|
    sp.source_files = ['SugarRecord/SugarRecord/Source/CoreData/**/*']
    sp.dependency 'SugarRecord/Foundation'
    sp.frameworks = ['CoreData']
  end

  s.subspec "Realm" do |sp|
    sp.source_files = ['SugarRecord/SugarRecord/Source/Realm/**/*']
    sp.dependency 'SugarRecord/Foundation'
    sp.dependency 'RealmSwift'
  end

end
