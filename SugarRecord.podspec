Pod::Spec.new do |s|
  s.name = 'SugarRecord'
  s.version = '1.0.7'
  s.platform = :ios, '7.0'
  s.license = 'MIT'
  s.summary = 'CoreData management library implemented with the sugar Swift language'
  s.homepage = 'https://github.com/SugarRecord/SugarRecord'
  s.author = { 'Pedro Piñera' => 'pepibumur@gmail.com' }
  s.social_media_url = "https://twitter.com/pepibumur"
  s.source = { :git => 'https://github.com/SugarRecord/SugarRecord.git', :tag => '1.0.7', :submodules => false }
  s.description = "Thanks to SugarRecord you'll be able to use a clean syntax to fetch, filter, create, update CoreData objects in an easy way. Inspired by MagicalRecord and opened to new contributions."
  s.requires_arc = true
  s.documentation_url = "https://github.com/SugarRecord/SugarRecord/wiki"

  s.subspec "Core" do  |sp|
    sp.source_files = ['library/Core/**/*.{swift}']
  end

  s.subspec "CoreData+RestKit" do  |sp|
    sp.frameworks = 'CoreData'
    sp.dependency 'RestKit'
    sp.dependency 'SugarRecord/Core'
    sp.source_files = ['library/CoreData/Base/**/*.{swift}', 'library/RestKit/**/*.{swift}']
  end

  s.subspec "CoreData" do  |sp|
    sp.frameworks = 'CoreData'
    sp.dependency 'SugarRecord/Core'
    sp.source_files = ['library/CoreData/Base/**/*.{swift}']
  end

  s.subspec "Realm" do |sp|
    sp.dependency 'Realm'
    sp.dependency 'SugarRecord/Core'
    sp.source_files = ['library/Realm/**/*.{swift}']
  end
end


