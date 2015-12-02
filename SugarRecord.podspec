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
  s.source_files = ['SugarRecord/SugarRecord/Source/Foundation/**/*']

  s.dependency 'Result', '~> 1.0'

  s.subspec "CoreData" do |sp|
    sp.watchos.deployment_target = '2.0'
    sp.tvos.deployment_target = '9.0'
    sp.ios.deployment_target = '8.0'
    sp.osx.deployment_target = "10.10"
    sp.source_files = ['SugarRecord/SugarRecord/Source/CoreData/**/*']
    sp.frameworks = ['CoreData']
  end

  s.subspec "Realm" do |sp|
    sp.ios.deployment_target = '8.0'
    sp.osx.deployment_target = "10.10"
    sp.source_files = ['SugarRecord/SugarRecord/Source/Realm/**/*']
    sp.dependency 'Realm', '~> 0.96'
  end
end
