Pod::Spec.new do |s|
  s.name = 'SugarRecord'
  s.version = '1.0.3'
  s.platform = :ios, '7.0'
  s.license = 'MIT'
  s.summary = 'CoreData management library implemented with the sugar Swift language'
  s.homepage = 'https://github.com/SugarRecord/SugarRecord'
  s.author = { 'Pedro Piñera' => 'pepibumur@gmail.com' }
  s.social_media_url = "https://twitter.com/pepibumur"
  s.source = { :git => 'https://github.com/SugarRecord/SugarRecord.git', :tag => '1.0.3' }
  s.description = "Thanks to SugarRecord you'll be able to use a clean syntax to fetch, filter, create, update CoreData objects in an easy way. Inspired by MagicalRecord and opened to new contributions."
  s.requires_arc = true
  s.documentation_url = "https://github.com/SugarRecord/SugarRecord/wiki"
  s.source_files = ['library/Core/**/*.{swift}']

  s.subspec "CoreData" do |coredata|
    coredata.frameworks = 'CoreData'
    coredata.name = "CoreData"
    coredata.source_files = 'library/CoreData/**/*.{swift}']
    coredata.exclude_files = ['library/CoreData/RestkitCDStack.swift']

    s.subspec "RestKit" do |restkit|
      restkit.name = "RestKit"
      restkit.dependency 'RestKit', '~> 0.24'
      restkit.source_files = ['library/CoreData/RestkitCDStack.swift']
    end
  end

  s.subspec "Realm" do |realm|
    realm.name = "Realm"
    coredata.source_files = ['library/Realm/**/*.{swift}']
  end
end


