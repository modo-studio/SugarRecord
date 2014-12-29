Pod::Spec.new do |s|
  s.name = 'SugarRecord'
  s.version = '1.0.5'
  s.platform = :ios, '8.0'
  s.license = 'MIT'
  s.summary = 'CoreData management library implemented with the sugar Swift language'
  s.homepage = 'https://github.com/SugarRecord/SugarRecord'
  s.author = { 'Pedro Piñera' => 'pepibumur@gmail.com' }
  s.social_media_url = "https://twitter.com/pepibumur"
  s.source = { :git => 'https://github.com/SugarRecord/SugarRecord.git', :tag => '1.0.5', :submodules => false }
  s.description = "Thanks to SugarRecord you'll be able to use a clean syntax to fetch, filter, create, update CoreData objects in an easy way. Inspired by MagicalRecord and opened to new contributions."
  s.requires_arc = true
  s.documentation_url = "https://github.com/SugarRecord/SugarRecord/wiki"

  s.subspec "CoreData+RestKit" do  |sp|
    sp.frameworks = 'CoreData'
    sp.dependency 'RestKit'
    sp.source_files = ['library/CoreData/Base/**/*.{swift}', 'library/Core/**/*.{swift}', 'library/RestKit/**/*.{swift}']
  end

  s.subspec "CoreData" do  |sp|
    sp.frameworks = 'CoreData'
    sp.source_files = ['library/CoreData/Base/**/*.{swift}', 'library/Core/**/*.{swift}']
  end

  s.subspec "Realm" do |sp|
    sp.dependency 'Realm'
    sp.source_files = ['library/Realm/**/*.{swift}', 'library/Core/**/*.{swift}']
  end
end


